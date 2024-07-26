pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "genaiihub24/my-docker:springboot-rest-v2"
        DOCKER_REGISTRY = 'docker.io'  // Docker Hub default registry
        EC2_USER = 'ubuntu'
        EC2_HOST = 'ec2-54-169-205-152.ap-southeast-1.compute.amazonaws.com'
        CONTAINER_NAME = 'my-springboot-app'  // Name of the container
    }
    stages {
        stage('Build') {
            steps {
                script {
                    // Build Docker image
                    def dockerImage = docker.build(DOCKER_IMAGE)
                }
            }
        }
        stage('Test') {
            steps {
                // Add your test commands here if any
                echo 'No tests configured'
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Docker login and push
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin $DOCKER_REGISTRY"
                        docker.image(DOCKER_IMAGE).push()
                    }
                    
                    // SSH and deploy
                    sshagent(['ec2-ssh-key']) {
                        sh """
                          ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST <<EOF
                          # Pull the new Docker image
                          docker pull $DOCKER_IMAGE
                          
                          # Get the container ID of the running container with the specific image
                          CONTAINER_ID=\$(docker ps -q -f "ancestor=$DOCKER_IMAGE")
                          
                          # Stop and remove the container if it exists
                          if [ -n "\$CONTAINER_ID" ]; then
                            docker stop \$CONTAINER_ID
                            docker rm \$CONTAINER_ID
                          fi
                          
                          # Run the new container with a specified name
                          docker run -d -p 8081:8081 --name $CONTAINER_NAME $DOCKER_IMAGE
                          EOF
                        """
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
