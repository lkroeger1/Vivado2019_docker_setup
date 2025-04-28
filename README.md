# Vivado HLS 2019.1 in Docker (with optional GUI support)

This repository provides a setup to run Vivado HLS 2019.1 inside a Docker container.  
It supports both command-line and GUI usage (with X11 forwarding).
Since Vivado HLS 2019.1 relies on outdated libraries and system dependencies, setting up a Docker container was the only reliable way for me to get it working on Ubuntu 24.04 (The problem is the C Simulation), i believe it wouldn't work on 20.04 upwards...

## Prerequisites

- Docker installed
- Vivado HLS 2019.1 installed on the host (e.g., in `/tools/Xilinx/Vivado/2019.1`)
- An X11 server running on the host (default on Linux desktop systems)
- `xhost` installed (needed to allow GUI applications from the container)

If you only need the command-line flow (batch mode), you can skip the X11 setup.

## Docker Setup

This repository includes a `Dockerfile` to build a clean Ubuntu 18.04 image with all libraries needed by Vivado HLS 2019.1.

### Building the Docker image

Run the following command in the folder containing the `Dockerfile`:

```bash
docker build -t ubuntu18-gcc7-vivado .
```

This will create a Docker image called `ubuntu18-gcc7-vivado` (will take 10 minutes).

## Starting the Docker Container

### 1. Allow X11 access (for GUI usage)

Run the following command on the host system:

```bash
xhost +
```

This allows Docker containers to connect to your X server.

### 2. Run the Docker container

**Important:**  
Before running the container, make sure to adjust the mounted paths (`-v` options) to match your system:

- `/tools/Xilinx` must point to your Vivado installation directory (where `settings64.sh` is located).
- `/home/larsk/Desktop/HLS/Project2/hls-refactoring-files` must point to your project folder.

Example:

```bash
docker run -it --rm \
    -e DISPLAY=$DISPLAY \
    -e HOME=/workspace \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /tools/Xilinx:/tools/Xilinx \            # <-- adjust this to your Vivado install path
    -v /home/larsk/Desktop/HLS/Project2/hls-refactoring-files:/workspace \   # <-- adjust this to your project folder
    ubuntu18-gcc7-vivado
```

### 3. Inside the container: source Vivado settings

Once inside the container, always run:

```bash
source /tools/Xilinx/Vivado/2019.1/settings64.sh
```

### 4. Start Vivado HLS

After sourcing the settings:

```bash
vivado_hls
```

You can now use Vivado HLS normally, including the GUI.

### 5. After finishing

For security, disable X11 access again after you exit the container:

```bash
xhost -
```

## Notes

- If GUI programs like `vivado_hls` do not open correctly, check:
  - `echo $DISPLAY` inside the container should output something like `:0`
  - `/tmp/.X11-unix` is correctly mounted into the container
  - GUI test programs like `xclock` or `zenity --info --text="Hello"` work inside the container
  - `xhost +` was run before starting the container
