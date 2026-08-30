# GCP & Kubernetes DevOps Automation Pipeline

A production-ready infrastructure and application deployment pipeline implementing GitOps practices. This project provisions Google Cloud Platform (GCP) infrastructure using Terraform and automates the continuous integration and continuous deployment (CI/CD) lifecycle of a containerized application via Jenkins, Docker, and Kubernetes (GKE).

---

## **Architecture Overview**

[ Git Repository ] ---> ( Jenkins Pipeline ) ---> [ Docker Build & Push ] ---> [ GCR Registry ] ---> [ GKE Cluster Deployment ]
        |
   ( Terraform / Ansible Infrastructure Management )

* **Infrastructure as Code (IaC):** Terraform modules for provisioning and managing cloud architecture.
* **CI/CD Orchestration:** Jenkins pipeline automating checkout, testing, container building, registry pushing, and rolling Kubernetes deployments.
* **Containerization:** Docker container packaging with image tagging per build number.
* **Orchestration:** Kubernetes (GKE / Private Cluster) managing pod lifecycles, services, and rolling updates in production namespaces.

---

## **Tech Stack**

* **Cloud Provider:** Google Cloud Platform (GCP) — Compute Engine, GKE, GCR, VPC, IAM.
* **Infrastructure as Code:** Terraform, Ansible.
* **CI/CD & Automation:** Jenkins, Docker, Git.
* **Container Orchestration:** Kubernetes, kubectl.
* **Linux Administration:** Red Hat Enterprise Linux / Rocky Linux / Ubuntu, Bash Shell Scripting.

---

## **Project Structure**

.
├── app/                  # Application source code and Dockerfile
├── terraform/            # GCP infrastructure definitions and modules
├── ansible/              # Configuration management playbooks
├── Jenkinsfile           # Declarative CI/CD pipeline definition
└── README.md

---

## **Pipeline Stages (`Jenkinsfile`)**

1. **Checkout Code:** Pulls the latest source code revisions from the designated GitHub repository branch.
2. **Build & Push Docker Image:** Authenticates securely with Google Container Registry (GCR) via service account credentials, builds the application image, tags it with the unique build number, and pushes it to GCR.
3. **Deploy to Kubernetes:** Configures cluster access credentials and executes a zero-downtime rolling image update on the target production deployment.

---

## **Setup & Installation**

### **1. Prerequisites**
* Terraform `>= 1.0`
* Docker Engine & Kubernetes CLI (`kubectl`)
* Jenkins Server equipped with Docker socket access and GCP Service Account credentials stored securely in Jenkins Credentials (`gcp-sa-key`).

### **2. Infrastructure Provisioning (Terraform)**
Navigate to the terraform directory, initialize the environment, and apply the configuration:

cd terraform/
terraform init
terraform plan
terraform apply

### **3. CI/CD Pipeline Configuration**
1. Link your GitHub repository to a Jenkins pipeline job.
2. Configure the Pipeline script path to point to the repository's `Jenkinsfile`.
3. Set up the secret file credential in Jenkins with ID `gcp-sa-key` containing your GCP service account JSON key.
4. Trigger a build via **Build Now** to execute the deployment workflow.
