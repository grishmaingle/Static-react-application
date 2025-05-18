pipeline {
    agent any

    tools {
        nodejs 'NodeJS'     // must match the name configured in Jenkins tools
    }

    environment {
        IMAGE_NAME = 'grishmaingle/react-static-app'
        SONARQUBE = 'MySonarQubeServer'  // name configured in Jenkins under "Manage Jenkins → Configure System"
    }

    stages {

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
            steps {
                withSonarQubeEnv("${env.SONARQUBE}") {
                    sh 'npx sonar-scanner -Dsonar.projectKey=StaticApp -Dsonar.sources=src -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_AUTH_TOKEN'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Scan Image with Trivy') {
            steps {
                sh 'trivy image $IMAGE_NAME'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }
    }
}
