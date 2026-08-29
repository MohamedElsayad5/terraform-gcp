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
        
        stage('2. Build & Push Docker Image') {
            steps {
                script {
                    withCredentials([file(credentialsId: env.CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh "/usr/bin/gcloud auth activate-service-account --key-file=\$GOOGLE_APPLICATION_CREDENTIALS"
                        sh "/usr/bin/gcloud auth configure-docker --quiet"
                        
                        // بناء الصورة ورفعها لـ Google Container Registry
                        appImage = docker.build("${env.IMAGE_NAME}:${env.BUILD_NUMBER}")
                        appImage.push()
                    }
                }
            }
        }
        
        stage('3. Deploy to Kubernetes') {
            steps {
                script {
                    // تحديث الصورة في الـ Deployment تلقائياً باستخدام المسار الكامل
                    sh "/usr/bin/kubectl set image deployment/vois-app vois-app=${env.IMAGE_NAME}:${env.BUILD_NUMBER} -n production"
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