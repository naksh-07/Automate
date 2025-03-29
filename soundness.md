# Soundness Docker Image 🚀  

This Docker image provides a pre-configured environment for **Soundness CLI**, along with **Rust and Cargo**.  

---

## 🔹 Quick Start: Using the Image  

Follow these simple steps to use **Soundness CLI** inside the Docker container:  

### Run the Container  

```console
docker run -it rohan014233/soundness:latest
```


```console
soundness-cli generate-key --name my-key
```

Importing a Key Pair
To import an existing key pair from a mnemonic phrase:

```console
soundness-cli import-key --name my-key
```

Listing Key Pairs
To view all stored key pairs and their associated public keys:

```console
soundness-cli list-keys
```

Exporting Key Mnemonic
To export the mnemonic phrase for a stored key pair:

```console
soundness-cli export-key --name my-key
```

📦 About the Project
This project provides a pre-configured and reproducible environment for working with Soundness CLI in Docker.

🛠 Features:
✅ Ubuntu 22.04 as the base image

🔗 Rust & Cargo installed via rustup

🔨 Soundness CLI installed and verified

🏗 Configured PATH environment to access binaries easily
