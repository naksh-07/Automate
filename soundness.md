# Soundness Docker Image 🚀  

This Docker image provides a pre-configured environment for **Soundness CLI**, along with **Rust and Cargo**.  

---

## 🔹 Quick Start: Using the Image  

Follow these simple steps to use **Soundness CLI** inside the Docker container:  

### 1️⃣ Run the Container  
```sh
docker run -it rohan014233/soundness:latest
2️⃣ Generate a New Key
sh
Copy
Edit
soundness-cli generate-key --name my-key
3️⃣ Export the Key
sh
Copy
Edit
soundness-cli export-key --name my-key
4️⃣ List All Keys
sh
Copy
Edit
soundness-cli list-keys
📦 About the Project
This project provides a pre-configured and reproducible environment for working with Soundness CLI in Docker.

🛠 Features:
✅ Ubuntu 22.04 as the base image

🔗 Rust & Cargo installed via rustup

🔨 Soundness CLI installed and verified

🏗 Configured PATH environment to access binaries easily
