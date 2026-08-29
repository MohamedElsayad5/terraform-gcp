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
                    // استخدام كونتينر Google Cloud SDK الجاهز لتنفيذ الأوامر بمعزل عن مشاكل الكونتينر الرئيسي
                    docker.image('google/cloud-sdk:latest').inside('--user root -v /var/run/docker.sock:/var/run/docker.sock') {
                        withCredentials([file(credentialsId: env.CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                            sh "gcloud auth activate-service-account --key-file=\$GOOGLE_APPLICATION_CREDENTIALS"
                            sh "gcloud auth configure-docker --quiet"
                            
                            // تثبيت وتفعيل أداة الـ docker داخل الكونتينر المؤقت لو مش موجودة
                            sh "apt-get update && apt-get install -y docker.io"
                            
                            appImage = docker.build("${env.IMAGE_NAME}:${env.BUILD_NUMBER}", "./app")
                            appImage.push()
                        }
                    }
                }
            }
        }
        
        stage('3. Deploy to Kubernetes') {
            steps {
                script {
                    docker.image('google/cloud-sdk:latest').inside('--user root') {
                        withCredentials([file(credentialsId: env.CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                            sh "gcloud auth activate-service-account --key-file=\$GOOGLE_APPLICATION_CREDENTIALS"
                            sh "gcloud container clusters get-credentials <cluster-name> --region <region> --project ${env.PROJECT_ID}"
                            sh "kubectl set image deployment/vois-app vois-app=${env.IMAGE_NAME}:${env.BUILD_NUMBER} -n production"
                        }
                    }
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