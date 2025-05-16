pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = 'github-creds'
        DOCKER_HUB_CREDENTIALS = 'docker-hub-creds'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: "${GIT_CREDENTIALS_ID}", branch: 'main', url: 'https://github.com/grishmaingle/Static-react-application.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh '''
                            sonar-scanner \
                              -Dsonar.projectKey=react-app \
                              -Dsonar.sources=. \
                              -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("grishmai28/react-app:latest")
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
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_HUB_CREDENTIALS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push grishmai28/react-app:latest'
                }
            }
        }
    }
}


