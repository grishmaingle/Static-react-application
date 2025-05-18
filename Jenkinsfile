pipeline {
    agent any

    tools {
        nodejs 'NodeJS'  // Make sure this matches your Jenkins NodeJS installation name
    }

    environment {
        IMAGE_NAME = 'grishmaingle/react-static-app'
        SONARQUBE_SERVER = 'MySonarQubeServer'
        SONAR_HOST_URL = 'http://15.206.23.10:9000'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh '''
                            npx sonar-scanner \
                              -Dsonar.projectKey=StaticApp \
                              -Dsonar.projectName=StaticReactApp \
                              -Dsonar.sources=src \
                              -Dsonar.host.url=${SONAR_HOST_URL} \
                              -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Scan Docker Image with Trivy') {
            steps {
                sh '''
                    trivy image --exit-code 0 --severity CRITICAL,HIGH ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
                        docker push ${IMAGE_NAME}:latest
                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
            // Optional: Clean up Docker images to save space
            sh 'docker rmi ${IMAGE_NAME}:latest || true'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for more details.'
        }
        always {
            // Clean up workspace if needed
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true)
        }
    }
}
