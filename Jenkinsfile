pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'SonarQube' // Configure this in Jenkins "Manage Jenkins > Configure System"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/grishmaingle/Static-react-application.git'
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

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh 'sonar-scanner'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t react-app .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image react-app'
            }
        }
    }
}
