pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonar-token')     // SonarQube token stored in Jenkins
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-creds') // Docker Hub credentials
        DOCKER_IMAGE = "your-dockerhub-username/react-app"
    }

    tools {
        nodejs "NodeJS_18"       // Ensure Node.js is installed and configured in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-creds', url: 'https://github.com/grishmaingle/Static-react-application.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        npm install
                        /var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/SonarQubeScanner/bin/sonar-scanner \
                        -Dsonar.projectKey=react-app \
                        -Dsonar.sources=. \
                        -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t $DOCKER_IMAGE:latest .
                """
            }
        }

        stage('Scan with Trivy') {
            steps {
                sh """
                    trivy image --exit-code 0 --severity CRITICAL,HIGH $DOCKER_IMAGE:latest
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh """
                    echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin
                    docker push $DOCKER_IMAGE:latest
                """
            }
        }
    }
}



