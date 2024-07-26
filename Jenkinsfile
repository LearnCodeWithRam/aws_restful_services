pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "genaiihub24/my-docker:springboot-rest-v2"
    DOCKER_REGISTRY = 'docker.io'  // Docker Hub default registry
    EC2_USER = 'ubuntu'
    EC2_HOST = 'ec2-54-169-205-152.ap-southeast-1.compute.amazonaws.com'
    DOCKER_USERNAME = 'genaiihub24'
    DOCKER_PASSWORD = 'Indore@452010'
    SSH_PRIVATE_KEY = '''-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACARO1Nk334VfsJH6dj2eCdE9Z2/CECI1pWxrN5ztjIVuQAAAKCqtFASqrRQ
EgAAAAtzc2gtZWQyNTUxOQAAACARO1Nk334VfsJH6dj2eCdE9Z2/CECI1pWxrN5ztjIVuQ
AAAEBQFLbzye8qgmKtXxLZiQnXHGI7jDgGXzwZBp0sZwEvPRE7U2TffhV+wkfp2PZ4J0T1
nb8IQIjWlbGs3nO2MhW5AAAAF3VidW50dUBpcC0xNzItMzEtMjAtMjI0AQIDBAUG
-----END OPENSSH PRIVATE KEY-----'''
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
          // Login to Docker registry
          sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin $DOCKER_REGISTRY"
          // Push Docker image
          docker.image(DOCKER_IMAGE).push()
        }
        script {
          // Write the SSH key to a temporary file
          writeFile file: '/tmp/id_rsa', text: "${SSH_PRIVATE_KEY.replace('\\n', '\n')}"
          // Set appropriate permissions for the SSH key
          sh "chmod 600 /tmp/id_rsa"
          // Deploy to EC2
          sh """
            ssh -o StrictHostKeyChecking=no -i /tmp/id_rsa $EC2_USER@$EC2_HOST <<EOF
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
  post {
    always {
      sh 'docker logout'
    }
  }
}

    