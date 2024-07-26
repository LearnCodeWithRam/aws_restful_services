pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "genaiihub24/my-docker:springboot-rest-v2"
        DOCKER_REGISTRY = 'docker.io'  // Docker Hub default registry
        EC2_USER = 'ubuntu'
        EC2_HOST = 'ec2-54-169-205-152.ap-southeast-1.compute.amazonaws.com'
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
                          docker pull $DOCKER_IMAGE
                          docker stop my-springboot-app || true
                          docker rm my-springboot-app || true
                          docker run -d -p 8081:8081 --name my-springboot-app $DOCKER_IMAGE
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
