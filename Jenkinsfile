pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'SonarQube'
        DOCKER_IMAGE = 'grishmai28/react-app:latest'
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
                    script {
                        def scannerHome = tool 'SonarQubeScanner'
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
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

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'grishmai28', passwordVariable: 'Grishma@25')]) {
                    sh """
                        echo "Grishma@25" | docker login -u "grishmai28" --password-stdin
                        docker push react-app
                    """
                }
            }
        }
    }
}

