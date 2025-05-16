
pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub-creds'
        GIT_CREDENTIALS_ID = 'github-creds'
    }

    tools {
        sonarRunner 'SonarQubeScanner' // Use 'sonarRunner' instead of sonarQubeScanner
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: "${env.github-creds}", branch: 'main', url: 'https://github.com/grishmaingle/Static-react-application.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        sonar-scanner \
                          -Dsonar.projectKey=react-app \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=http://localhost:9000 \
                          -Dsonar.login=<sqa_937947b4520ab7b024e8824ab8685ce501799488>
                    """
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
                withCredentials([
                    usernamePassword(
                        credentialsId: env.github-creds,
                        usernameVariable: 'grishmai28',
                        passwordVariable: 'Grishma@25'
                    )
                ]) {
                    sh 'echo $Grishma@25 | docker login -u $grishmai28 --password-stdin'
                    sh 'docker push grishmai28/react-app:latest'
                }
            }
        }
    }
}
