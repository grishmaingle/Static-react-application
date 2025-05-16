pipeline {
    agent any

    // Jenkins credentials ID for Docker Hub (username/password)
    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub-creds' 
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the React application from GitHub
                git branch: 'main',
                    url: 'https://github.com/grishmai28/react-app.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Run SonarQube scanner using the SonarQube server configured in Jenkins (named "SonarQube")
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner -Dsonar.projectKey=react-app -Dsonar.sources=. ' +
                       '-Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_AUTH_TOKEN'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build and tag the Docker image for Docker Hub
                    dockerImage = docker.build('grishmai28/react-app:latest')
                }
            }
        }

        stage('Scan with Trivy') {
            steps {
                // Scan the newly built image with Trivy
                sh 'trivy image grishmai28/react-app:latest'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                // Log in to Docker Hub using Jenkins-stored credentials, then push the image
                withCredentials([
                    usernamePassword(
                        credentialsId: env.docker-hub-creds, 
                        usernameVariable: 'grishmai28', 
                        passwordVariable: 'Grishma@25'
                    )
                ]) {
                    sh 'echo $Grishma@25 | docker login -u $grishmai28 --password-stdin'
                }
                sh 'docker push grishmai28/react-app:latest'
            }
        }
    }
}
