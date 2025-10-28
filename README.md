# 🚀 Hybrid DevOps CI/CD Pipeline Project

## 🧩 Project Title & Description

**Hybrid DevOps CI/CD Pipeline for Automated Build, Test, Deploy, and Monitoring**

This project demonstrates a **complete end-to-end DevOps CI/CD workflow** that automates:
- Source code build and quality analysis using **Jenkins + SonarQube**
- Containerization using **Docker**
- Deployment to **AWS EC2**
- Monitoring and visualization using **Prometheus + Grafana**

The objective is to simulate an industry-grade pipeline that provides continuous integration, continuous delivery, and continuous monitoring for a modern web application.

---

## ⚙️ Tech Stack

| Category | Tools / Technologies Used |
|-----------|---------------------------|
| **Version Control** | Git, GitHub |
| **CI/CD Automation** | Jenkins |
| **Build Tool** | Maven / npm |
| **Containerization** | Docker |
| **Deployment** | AWS EC2 |
| **Monitoring** | Prometheus, Node Exporter, Grafana |
| **Integration Utility** | ngrok (for external webhooks) |
| **Backup Automation** | Cron jobs (Linux) |

---

## 🧰 Setup Instructions

### 🖥️ Run Locally (Ubuntu)

#### 1️⃣ Clone the Repository
```bash
git clone https://github.com/<your-username>/devops-capstone-app.git
cd devops-capstone-app

2️⃣ Install Dependencies

If Node.js app:

npm install

3️⃣ Run the Application
npm start

Visit:

http://localhost:3000

🐳 Run with Docker Locally
docker build -t your-dockerhub-username/devops-capstone-app:local .
docker run -d -p 3000:3000 your-dockerhub-username/devops-capstone-app:local


Access locally:

http://localhost:3000

☁️ Quick Deploy on AWS EC2
1️⃣ Launch EC2 Instance

Ubuntu 22.04 (t2.micro)

Allow inbound: 22, 3000, 9090, 9100 ports

2️⃣ SSH into EC2
ssh -i ~/Downloads/ec2key.pem ubuntu@<EC2_PUBLIC_IP>

3️⃣ Install Docker
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu

4️⃣ Deploy Application
docker pull your-dockerhub-username/devops-capstone-app:<tag>
docker run -d --name devops-capstone-app-container -p 3000:3000 your-dockerhub-username/devops-capstone-app:<tag>


Access deployed app:

http://<EC2_PUBLIC_IP>:3000

🔄 CI/CD Flow (Explained Briefly)

The pipeline is implemented using Jenkins Declarative Pipeline (Jenkinsfile) and automates all major DevOps stages.

1️⃣ Build Stage

Triggered automatically on GitHub push (via webhook)

Jenkins pulls the latest code from GitHub

Maven or npm build is executed

3️⃣ Docker Build & Push Stage

Jenkins builds a Docker image from the app

Tags and pushes it to DockerHub repository

4️⃣ Deploy Stage

Jenkins connects to AWS EC2 using SSH credentials (ec2-ssh)

Executes deploy.sh on EC2 to stop old container and run the new one

5️⃣ Monitor Stage

Node Exporter on EC2 collects system metrics

Prometheus scrapes metrics from:

Node Exporter (port 9100)

Application (/metrics on port 3000)

Grafana visualizes metrics dashboards

📊 Pipeline Flow Overview
 GitHub → Jenkins → SonarQube → DockerHub → AWS EC2 → Prometheus → Grafana


Tools in action:

Jenkins automates the entire pipeline

Docker enables portability and fast deployment

EC2 serves as the host server

Prometheus + Grafana provide observability and alerting

