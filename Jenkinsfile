pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub-creds'
        GIT_CREDENTIALS_ID = 'github-creds' // The ID you just created
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
      script {
        def scannerHome = tool 'SonarQubeScanner'
        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=react-app -Dsonar.sources=."
      }
    }
  }
}


        stage('Build Docker Image') {
            steps {
                script {
                    // Build and tag the Docker image for Docker Hub
                    def dockerImage = docker.build("grishmai28/react-app:latest")
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
