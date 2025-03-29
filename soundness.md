```md
# 🚀 Soundness Docker Image  

This Docker image provides a **pre-configured environment** for **Soundness CLI**, along with **Rust and Cargo**.  

---

## 🔹 Quick Start  

### 🏗 Run the Container  
```console
docker run -it rohan014233/soundness:latest
```

### 🔑 Generate a Key Pair  
```console
soundness-cli generate-key --name my-key
```

### 📥 Import an Existing Key  
```console
soundness-cli import-key --name my-key
```

### 📋 List All Stored Keys  
```console
soundness-cli list-keys
```

### 🔐 Export Key Mnemonic  
```console
soundness-cli export-key --name my-key
```

---

## 📦 About This Project  

This Docker setup provides a **reproducible** and **hassle-free** environment to use **Soundness CLI**.  

### 🛠 Features:  
✅ **Ubuntu 22.04** as the base image  
🔗 **Rust & Cargo** installed via `rustup`  
🔨 **Soundness CLI** pre-installed & verified  
🏗 **Configured PATH** for easy access to binaries  

---

🚀 **Get started in seconds!** 🔥  
```sh
docker run -it rohan014233/soundness:latest
```
```
