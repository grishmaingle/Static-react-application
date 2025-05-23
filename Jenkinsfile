pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'
        DOCKER_IMAGE = 'grishmai28/react-app'
    }

    tools {
        nodejs 'NodeJS'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'git-creds', url: 'https://github.com/grishmaingle/Static-react-application.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
                    withSonarQubeEnv("${SONARQUBE_SERVER}") {
                        sh '''
                            npx sonar-scanner \
                            -Dsonar.projectKey=static-react-app \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://15.206.23.10:9000 \
                            -Dsonar.login=$SONAR_AUTH_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    mkdir -p $HOME/.local/bin
                    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b $HOME/.local/bin
                    export PATH=$HOME/.local/bin:$PATH
                    trivy image ${DOCKER_IMAGE}:latest
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh """
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker push ${DOCKER_IMAGE}:latest
                        """
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@15.206.23.10 "
                                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin &&
                                docker pull ${DOCKER_IMAGE}:latest &&
                                docker rm -f react-app-container || true &&
                                docker run -d -p 80:80 --name react-app-container ${DOCKER_IMAGE}:latest
                            "
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
