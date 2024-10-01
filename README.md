# 🚀 Embarcadero InterBase in Docker 🚀  <a href="https://www.embarcadero.com/products/interbase"><img src="https://user-images.githubusercontent.com/821930/228645057-cc7e2bad-eac7-4c12-8250-089aa4cf77f1.png" align="right" alt="Embarcadero InterBase"></a>

**Award-Winning SQL Database**  
Embarcadero InterBase, winner of Total Telco's IoT Award for **"The Most Innovative Use of Data"**, is a powerful, scalable, and secure relational database. Built for cross-platform applications, it offers ultra-fast performance, multi-dimensional security, and patented **Change Views** technology to track changes in your data, making it ideal for IoT and embedded environments.

- **Container available on [Docker Hub](https://hub.docker.com/r/radstudio/interbase)**
- [InterBase Documentation](https://docwiki.embarcadero.com/InterBase/2020/en/Main_Page)
- Other containers: [PAServer](https://github.com/Embarcadero/paserver-docker), [RAD Server](https://github.com/Embarcadero/pa-radserver-docker), and [RAD Server with InterBase](https://github.com/Embarcadero/pa-radserver-ib-docker)

## ⚡ Key Features  
- **Blazing Fast**: Ultrafast database engine with minimal overhead.
- **Multi-Platform**: Embeddable across Windows, Linux, macOS, iOS, and Android.
- **Zero Admin**: Low maintenance, fully scalable, and easily embeddable in applications.
- **Patented Change Views**: Track changes with unparalleled speed and security.
- **Multi-Dimensional Security**: Full encryption and security layers for maximum data protection.
- **Disaster Recovery & Sync**: Robust mechanisms for data recovery and synchronization.

---

## 🛠️ How to Use InterBase with Docker

Setting up InterBase with Docker is a breeze! 🐳 Just follow these steps:

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/Embarcadero/InterBase-Docker.git
   cd InterBase-Docker
   ```

2. **Run the [`run.sh`] Script**  
   Use the `run.sh` script to spin up your InterBase instance with Docker with your preferred options. Below are the instructions to utilize this script effectively.
   ```bash
   ./run.sh -d --name my_database --port 3050 --version latest
   ```
   This script automates the entire setup, ensuring everything is configured properly!

3. **Run using Docker Run - not necessary to clone the repository**  
   Use the image available on `DockerHub` and run your container directly with `Docker Run`.
   ```bash
   docker run -it -p 3050:3050 --name interbase --mount source=iblicense,target=/opt/interbase/license --mount source=interbase,target=/opt/interbase radstudio/interbase:latest
   ```
---

## 🔑 Registration: Quick & Simple  

The first time you run InterBase, you’ll need to register. Here's how to do it effortlessly:

1. Run the container and wait for the console to display registration options.
2. Select **Option 2** for direct registration (the easiest method).
3. Enter your **serial number** and **account details**.
4. Your license will be saved at `/opt/interbase/license` by default.

🔒 **Your license is securely stored, so you only need to do this once!** 

---

## 💻 Usage Guide: Running InterBase with Docker

You can manage your InterBase instance using the `run.sh` script with these helpful options:

- **--name**: Assign a name to the container (default: `interbase`).
- **--port**: Specify a port for InterBase to listen on (default: `3050`).
- **--version**: Select the desired version (e.g., `latest`, `2020.4`).
- **--detach**: To run the container in detached mode (in the background).
- **--help**: Display usage help for the script.

Here’s an example command:
```bash
./run.sh -d --name my_database --port 3050 --version latest
```

---

## 🗃️ Volumes: Data Persistence Done Right

We use **Docker Volumes** to persist your databases by default, which offers several advantages:

- **Improved Performance**: Volumes operate at higher speeds compared to binds as they are managed natively by Docker.
- **Reduced Failure Risk**: Unlike binds, volumes are less prone to filesystem failures, ensuring your data remains safe and accessible.
- **No Manual Setup Needed**: Volumes are automatically handled by Docker, so you don’t need to worry about configuration issues or latency concerns.

✨ With volumes, your data is always secure, fast, and ready to go!

---

## 🐳 For Power Users: Using Docker Run Directly

For users who prefer to dive straight into the command line, you can skip the `run.sh` script and manage the container directly with `docker run`.

Here’s a basic example:
```bash
docker run -it -p 3050:3050 --name interbase --mount source=iblicense,target=/opt/interbase/license --mount source=interbase,target=/opt/interbase radstudio/interbase:latest
```

You can add extra flags or adjust settings as needed for your environment.

### 🛠️ Command Structure

The basic structure of the command to run the InterBase Docker container is as follows:

```bash
docker run [OPTIONS] radstudio/interbase:[VERSION]
```

### 🏗️ Building Your Custom Image

After customizing your Dockerfile, you can build your Docker image using the docker build command.

```bash
docker build -t my-custom-interbase:latest .
```

### 💡 Tips

- This repository provides a [`build.sh`] script that can be used as a template for simplifying custom builds.
- Currently, this image is only compatible with `linux/amd64`. To avoid potential problems in arm setups, build the image with the arg `--platform linux/amd64`

---

## 🚀 Start Building with Embarcadero InterBase Today!  
InterBase offers unmatched performance, security, and ease of use for developers looking to embed a robust SQL database into their cross-platform applications.
---

_This software is Copyright &copy; 2023 by [Embarcadero Technologies, Inc.](https://www.embarcadero.com/)_

_You may only use this software if you are an authorized licensee of Embarcadero [InterBase](https://www.embarcadero.com/products/interbase/). See the latest [software license agreement](https://www.embarcadero.com/products/interbase/interbase-eula) for updates or changes._

![Embarcadero(Black-100px)](https://user-images.githubusercontent.com/821930/211648635-c0db6930-120c-4456-a7ea-dc7612f01451.png#gh-light-mode-only)
![Embarcadero(White-100px)](https://user-images.githubusercontent.com/821930/211649057-7f1f1f07-a79f-44d4-8fc1-87c819386ec6.png#gh-dark-mode-only)
