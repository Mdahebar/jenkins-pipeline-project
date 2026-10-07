stage('Deploy to Production') {
            steps {
                echo "=== Step 5: Deploying Container to Production (Port 80) ==="
                // 1. Docker Hub se latest image pull karo
                sh "docker pull ${env.DOCKER_REPO}/${env.IMAGE_NAME}:latest"
                
                // 2. Agar purana prod container chal raha hai toh use hatao
                sh "docker rm -f prod-container || true"
                
                // 3. Naya container port 80 par live run karo
                sh "docker run -d -p 80:80 --name prod-container ${env.DOCKER_REPO}/${env.IMAGE_NAME}:latest"
                
                echo "Application successfully deployed to Production!"
            }
        }
