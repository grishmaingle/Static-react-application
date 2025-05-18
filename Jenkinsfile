pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'
        DOCKER_IMAGE = 'grishmaingle/static-react-app'
    }

    tools {
        nodejs 'NodeJS'  // Ensure NodeJS is installed in Jenkins tools (adjust name if different)
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
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh 'npx sonar-scanner \
                        -Dsonar.projectKey=static-react-app \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://15.206.23.10:9000 \
                        -Dsonar.login=${SONAR_AUTH_TOKEN}'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        docker push ${DOCKER_IMAGE}:latest
                    """
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
