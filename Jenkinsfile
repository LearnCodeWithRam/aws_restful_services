pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker_registry_creds'
        SSH_KEY_ID = 'ssh-key'
        DOCKER_IMAGE = 'genaiihub24/my-docker:springboot-rest-v2'
        CONTAINER_NAME = 'my-springboot-app'
        EC2_HOST = 'ubuntu@ec2-54-169-205-152.ap-southeast-1.compute.amazonaws.com'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Login to Docker Hub
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'

                        // Tag and push the Docker image
                        sh 'docker tag $DOCKER_IMAGE $DOCKER_USERNAME/$DOCKER_IMAGE'
                        sh 'docker push $DOCKER_USERNAME/$DOCKER_IMAGE'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_KEY_ID, keyFileVariable: 'SSH_KEY')]) {
                    script {
                        // Stop and remove existing container if it exists
                        sh '''
                        #!/bin/bash
                        set -e
                        CONTAINER_ID=$(ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_HOST "docker ps -q -f name=$CONTAINER_NAME")
                        if [ -n "$CONTAINER_ID" ]; then
                            ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_HOST "docker stop $CONTAINER_ID && docker rm $CONTAINER_ID"
                        fi

                        # Pull the latest image and start a new container
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_HOST "
                        docker pull $DOCKER_IMAGE
                        docker run -d -p 8081:8081 --name $CONTAINER_NAME $DOCKER_IMAGE
                        "
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
