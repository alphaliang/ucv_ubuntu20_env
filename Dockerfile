FROM ubuntu:20.04

# Set noninteractive installation to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary tools
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git zip unzip tar \
    build-essential \
    software-properties-common \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    tk-dev \
    libffi-dev \
    uuid-dev \
    python3 python3-pip\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Download, build, and install CMake 4.0.0
RUN cd /tmp && wget https://github.com/Kitware/CMake/releases/download/v4.0.1/cmake-4.0.1-linux-x86_64.sh \
    && chmod +x cmake-4.0.1-linux-x86_64.sh \
    && ./cmake-4.0.1-linux-x86_64.sh --skip-license --prefix=/usr/local \
    && rm -f /tmp/*

# Download, build, and install GoogleTest
    
RUN cd /tmp \
        && wget   https://github.com/google/googletest/archive/refs/tags/release-1.10.0.zip \
        && unzip release-1.10.0.zip \
        && cd googletest-release-1.10.0 \
        && mkdir build \
        && cd build \
        && cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        && make -j$(nproc) \
        && make install \
        && cd / \
        && rm -rf /tmp/googletest-release-1.10.0 /tmp/release-1.10.0.zip

# Make sure the Python SSL module works and install requests
#ldconfig && \
RUN python3 -m pip install --no-cache-dir requests pyyaml 
#RUN python3 -c "import requests; print(requests.get('https://www.google.com').status_code)"  

# Verify installations
#RUN python3 --version && \
#    pip3 --version && \
#    gcc --version && \
#    cmake --version && \
#    python3 -c "import requests; print(f'requests {requests.__version__} installed successfully')"

# Set working directory
WORKDIR /app
