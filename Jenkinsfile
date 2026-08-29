pipeline {
    agent {
        docker {
            image 'google/cloud-sdk:latest'
            args '--user root'
        }
    }
    
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
                        sh "gcloud auth activate-service-account --key-file=\$GOOGLE_APPLICATION_CREDENTIALS"
                        sh "gcloud auth configure-docker --quiet"
                        
                        // بناء الصورة باستخدام أداة الـ Docker الخارجية المتاحة على الهوست
                        sh "docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ./app"
                        sh "docker push ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    }
                }
            }
        }
        
        stage('3. Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: env.CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh "gcloud auth activate-service-account --key-file=\$GOOGLE_APPLICATION_CREDENTIALS"
                        // لو محتاج تتصل بالكلاستر مباشرة من البايبلان
                        sh "gcloud container clusters get-credentials <cluster-name> --region <region> --project ${env.PROJECT_ID}"
                        sh "kubectl set image deployment/vois-app vois-app=${env.IMAGE_NAME}:${env.BUILD_NUMBER} -n production"
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