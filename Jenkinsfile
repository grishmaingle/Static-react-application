pipeline {
    agent any

    tools {
        sonarQubeScanner 'SonarQubeScanner' // must match the name in Jenkins global tools
    }

    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub-creds'
        GIT_CREDENTIALS_ID = 'github-creds'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: "${github-creds}", branch: 'main', url: 'https://github.com/grishmaingle/Static-react-application.git'
            }
        }


   stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner -Dsonar.projectKey=static-react-app -Dsonar.sources=src'
                }
            }
        }


        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("grishmai28/react-app:latest")
                }
            }
        }

        stage('Scan with Trivy') {
            steps {
                sh 'trivy image grishmai28/react-app:latest || true'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${docker-hub-creds}",
                        usernameVariable: 'grishmai28',
                        passwordVariable: 'Grishma@25'
                    )
                ]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push grishmai28/react-app:latest'
                }
            }
        }
    }
}

