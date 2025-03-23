FROM --platform=linux/amd64 debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip \
    wget \
    libgl1-mesa-glx \
    libxi6 \
    libxrender1 \
    libxkbcommon0 \
    libxfixes3 \
    libsm6 \
    libxxf86vm1 \
    xz-utils \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Blender
WORKDIR /tmp
RUN wget -q https://mirrors.ocf.berkeley.edu/blender/release/Blender3.6/blender-3.6.0-linux-x64.tar.xz \
    && tar -xf blender-3.6.0-linux-x64.tar.xz -C /opt \
    && rm blender-3.6.0-linux-x64.tar.xz \
    && ln -s /opt/blender-3.6.0-linux-x64/blender /usr/local/bin/blender

# Setup working directory
WORKDIR /app

# Copy application files
COPY . /app/

# Install the application using Blender's Python
RUN /opt/blender-3.6.0-linux-x64/3.6/python/bin/python3.10 -m pip install --no-cache-dir -e .

# Expose port
EXPOSE 8000

# Run the application using Blender's Python
CMD ["/opt/blender-3.6.0-linux-x64/blender", "--background", "--python", "/app/src/bpy2obj/server.py", "--", "--host", "0.0.0.0", "--port", "8000"] 