pipeline {
    agent {
        kubernetes {
            defaultContainer 'docker'
            yaml """
apiVersion: v1
kind: Pod
spec:
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
  containers:
    - name: docker
      image: docker:latest
      imagePullPolicy: IfNotPresent
      command:
        - cat
      tty: true
      volumeMounts:
        - mountPath: /var/run/docker.sock
          name: docker-sock
"""
        }
    }

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
                withCredentials([file(credentialsId: "${KUBECONFIG_CREDENTIAL_ID}", variable: 'KUBECONFIG')]) {
                    sh '''
                        export KUBECONFIG=$KUBECONFIG
                        kubectl set image deployment/sample-deployment sample-container=$DOCKER_IMAGE || kubectl apply -f k8s-deployment.yaml
                        kubectl get pods
                    '''
                }
            }
        }

        stage('Show Logs') {
            steps {
                sh '''
                    kubectl get pods
                    kubectl logs -l app=sample-app --tail=100
                '''
            }
        }
    }
}
