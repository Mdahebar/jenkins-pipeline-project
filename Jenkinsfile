pipeline {
    agent any

    environment {
        APP_NAME = 'DevOps-Core-App'
        APP_VERSION = '2.0.0'
    }

    stages {
        stage('Checkout & Verify') {
            steps {
                echo "=== Step 1: Code fetched via SCM ==="
                sh 'ls -la'
            }
        }

        stage('Build Simulation') {
            steps {
                echo "=== Step 2: Building ${env.APP_NAME} version ${env.APP_VERSION} ==="
                sh '''
                    mkdir -p dist
                    echo "App Name: ${APP_NAME}" > dist/app.info
                    echo "Release Version: ${APP_VERSION}" >> dist/app.info
                    cat dist/app.info
                '''
            }
        }

        stage('Unit Testing') {
            steps {
                echo "=== Step 3: Running automated validation ==="
                sh '''
                    if [ -f dist/app.info ]; then
                        echo "File verification passed!"
                    else
                        exit 1
                    fi
                '''
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo "=== Step 4: Archiving output file ==="
                archiveArtifacts artifacts: 'dist/*.info', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "Success: Release ${env.APP_VERSION} built and archived!"
        }
    }
}
