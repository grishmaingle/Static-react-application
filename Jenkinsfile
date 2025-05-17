pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonar-token')
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-creds')
        DOCKER_IMAGE = "grishmai28/react-app"
    }

    stages {
        stage('Checkout') {
            steps {
git branch: 'main', url: 'https://github.com/grishmaingle/Static-react-application.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        npm install
                        sonar-scanner \
                          -Dsonar.projectKey=react-app \
                          -Dsonar.sources=. \
                          -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE:latest ."
            }
        }

        stage('Scan with Trivy') {
            steps {
                sh "trivy image --exit-code 0 --severity CRITICAL,HIGH $DOCKER_IMAGE:latest"
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


