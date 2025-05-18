pipeline {
    agent any

    tools {
        nodejs 'NodeJS'  // Ensure this name matches your Jenkins NodeJS tool config
    }

    environment {
        IMAGE_NAME = 'grishmaingle/react-static-app'
        SONARQUBE = 'MySonarQubeServer' // Name configured in Jenkins
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
                withSonarQubeEnv("${env.SONARQUBE}") {
                    sh '''
                        npx sonar-scanner \
                        -Dsonar.projectKey=StaticApp \
                        -Dsonar.projectName=StaticReactApp \
                        -Dsonar.sources=src \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $IMAGE_NAME:latest .
                '''
            }
        }

        stage('Scan Docker Image with Trivy') {
            steps {
                sh '''
                    trivy image --exit-code 0 --severity CRITICAL,HIGH $IMAGE_NAME:latest
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for more details.'
        }
    }
}

}
