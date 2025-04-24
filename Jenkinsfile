pipeline {
    agent  any

    environment {
        DOCKER_IMAGE = 'komall6/sample-node-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Dhanvikah/sample-node-docker-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                    sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).push("latest")
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s-deploy.yaml
                    '''
            }
        }
    }
}

