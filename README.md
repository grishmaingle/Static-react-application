“We’ve created a full CI/CD pipeline for a React static app. Developers push code to GitHub. Jenkins automatically pulls this code, checks it for quality using SonarQube, scans it for vulnerabilities using Trivy, builds a Docker image, and deploys it. On the server, all services run inside Docker containers. For monitoring, Prometheus collects data, cAdvisor tracks container health, and Grafana visualizes everything. This ensures quality, security, and visibility at every stage of our pipeline.”
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
List of technologies and tools with a short description.

- React – Frontend app
- Jenkins – CI/CD automation
- SonarQube – Code quality analysis
- Trivy – Vulnerability scanning
- Docker – Containerization
- Prometheus – Metrics monitoring
- Grafana – Metrics visualization
- cAdvisor – Container monitoring
- GitHub – Version control
- AWS EC2 – Hosting environment

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Pipeline Flow

Developer pushes code to GitHub.

Jenkins pipeline starts:
   - Clones repo
   - Runs SonarQube for code check
   - Runs Trivy for vulnerabilities
   - Builds and pushes Docker image
   - Deploys app to EC2

Monitoring is set up with Prometheus, Grafana, and cAdvisor.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------Folder/Files Explanation

Dockerfile: Builds your React app container

Jenkinsfile: Pipeline steps for Jenkins

prometheus.yml: Config for Prometheus monitoring

"C:\Users\lenovo\Pictures\Screenshots\Screenshot (257).png"
- Security groups that have to import
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
- Connected to EC2
"C:\Users\lenovo\Pictures\Screenshots\Screenshot (256).png"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
"C:\Users\lenovo\Pictures\Screenshots\Screenshot (255).png"
- SonarQube Dashboard
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
- CI/CD pipeline 
"C:\Users\lenovo\Pictures\Screenshots\Screenshot (254).png"
![Screenshot 2025-05-16 171743](https://github.com/user-attachments/assets/07c0a321-afd4-4c8b-9308-63a4f6582b07)
cretentials 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
- cAdvisory Dashboard shows the CPU ram
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
- Prometheus setup
- ![Screenshot 2025-05-19 231308](https://github.com/user-attachments/assets/d5b731d6-7872-4528-8054-6da8fd0950c8)
- ![Screenshot 2025-05-20 003128](https://github.com/user-attachments/assets/460923da-4650-4ed5-86ee-5c071104a4c7)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
- Visuallization from grafana
![Screenshot 2025-05-19 233236](https://github.com/user-attachments/assets/5218f012-09d4-4cea-8d3f-f58317c55581)
![Screenshot 2025-05-19 230927](https://github.com/user-attachments/assets/c228f371-4d4d-472c-bd66-a95fd17ae106)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
- Deploy Docker image in Dockerhub
![Screenshot 2025-05-19 010613](https://github.com/user-attachments/assets/5988bc4c-e0cc-4b78-b5f6-5a2ee38ad262)
![Screenshot 2025-05-19 144528](https://github.com/user-attachments/assets/3afe27db-cdf0-4131-a06a-41ffb6718ef1)


