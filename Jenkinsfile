pipeline {
    agent any

    environment {
        APP_NAME    = 'DevOps-Core-App'
        APP_VERSION = '2.1.0'
        IMAGE_NAME  = 'devops-app'
    }

    stages {
        stage('Checkout & Verify') {
            steps {
                echo "=== Step 1: Code fetched via SCM ==="
                sh 'ls -la'
            }
        }

        stage('Docker Build') {
            steps {
                echo "=== Step 2: Building Docker Image for Build #${env.BUILD_NUMBER} ==="
                // Current directory (.) se Dockerfile read karke image build karega
                sh "docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
            }
        }

        stage('Docker Test & Validate') {
            steps {
                echo "=== Step 3: Running Container & Validating Response ==="
                // Background me container run karega aur host port 8081 ko map karega
                sh "docker run -d -p 8081:80 --name test-container ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                
                // 3 second wait taaki Nginx process ready ho jaye
                sh "sleep 3"
                
                // Verification: check if web server returns our custom HTML
                sh "curl -s http://localhost:8081 | grep 'DevOps CI/CD Pipeline'"
                echo "Container test passed successfully!"
            }
        }
    }

    post {
        always {
            echo "=== Step 4: Cleanup Testing Container ==="
            // Har halat me test container ko delete karega taaki port 8081 free ho jaye
            sh "docker rm -f test-container || true"
        }
        success {
            echo "Success: Docker image ${env.IMAGE_NAME}:${env.BUILD_NUMBER} built and verified!"
        }
        failure {
            echo "Failure: Docker pipeline failed!"
        }
    }
}
