pipeline {
    agent any
environment {
    SONAR_TOKEN = credentials('sonar-token')  
}
    stages {
        stage('Checkout') {
            steps {
git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/grishmaingle/Static-react-application.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    script {
                        def scannerHome = tool 'SonarQubeScanner'
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=react-app -Dsonar.sources=. -Dsonar.login=${SONAR_TOKEN}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker Image...'
                // Your docker build steps here
            }
        }

        stage('Scan with Trivy') {
            steps {
                echo 'Scanning with Trivy...'
                // Your Trivy scan steps here
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing to Docker Hub...'
                // Your docker push steps here
            }
        }
    }
}



