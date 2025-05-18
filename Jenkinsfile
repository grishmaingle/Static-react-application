pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "grishmai28/react-app"
    }

    tools {
        nodejs "NodeJS 18"  // NodeJS name you set in Jenkins
    }

    stages {
        stage('Clone Code') {
            steps {
                git 'https://github.com/grishmaingle/Static-react-application.git'
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

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'SonarQube Scanner'
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=static-react-app -Dsonar.sources=. -Dsonar.exclusions=**/node_modules/**,**/build/**"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Scan Image with Trivy') {
            steps {
                sh "trivy image --exit-code 0 --severity HIGH,CRITICAL $DOCKER_IMAGE"
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }
    }
}


