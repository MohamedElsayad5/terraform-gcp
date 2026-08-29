pipeline {
    agent any
    
    environment {
        PROJECT_ID = "terraform-gcp-506723"
        IMAGE_NAME = "gcr.io/${env.PROJECT_ID}/vois-app"
        CREDENTIALS_ID = "gcp-sa-key"
    }
    
    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('2. Install Tools & Authenticate') {
            steps {
                sh '''
                    if ! command -v gcloud &> /dev/null; then
                        echo "Installing gcloud CLI..."
                        apt-get update && apt-get install -y curl apt-transport-https ca-certificates gnupg
                        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
                        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
                        apt-get update && apt-get install -y google-cloud-cli kubectl
                    fi
                '''
            }
        }
        
        stage('3. Build & Push Docker Image') {
            steps {
                script {
                    withCredentials([file(credentialsId: env.CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh "gcloud auth activate-service-account --key-file=\$GOOGLE_APPLICATION_CREDENTIALS"
                        sh "gcloud auth configure-docker --quiet"
                        
                        appImage = docker.build("${env.IMAGE_NAME}:${env.BUILD_NUMBER}")
                        appImage.push()
                    }
                }
            }
        }
        
        stage('4. Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl set image deployment/vois-app vois-app=${env.IMAGE_NAME}:${env.BUILD_NUMBER} -n production"
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully! App is deployed.'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}