pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'  // Matches your Jenkins SonarQube config name
        DOCKER_IMAGE = 'grishmai28/react-app'   // Corrected to your DockerHub repo
    }

    tools {
        nodejs 'NodeJS'  // Ensure this matches your Jenkins NodeJS tool name
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'git-creds', url: 'https://github.com/grishmaingle/Static-react-application.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
                    withSonarQubeEnv("${SONARQUBE_SERVER}") {
                        sh 'npx sonar-scanner ' +
                           '-Dsonar.projectKey=static-react-app ' +
                           '-Dsonar.sources=. ' +
                           '-Dsonar.host.url=http://15.206.23.10:9000 ' +
                           '-Dsonar.login=$SONAR_AUTH_TOKEN'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
