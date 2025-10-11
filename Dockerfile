FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set locale to avoid issues with some tools
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Install basic dependencies and Ruby/Node build requirements
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    build-essential \
    stow \
    locales \
    ca-certificates \
    unzip \
    wget \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libyaml-dev \
    libffi-dev \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install mise
RUN curl https://mise.run | sh
ENV PATH="/root/.local/bin:${PATH}"

# Install oh-my-posh
RUN curl -s https://ohmyposh.dev/install.sh | bash -s

# Create dotfiles directory structure
WORKDIR /root/dotfiles

# Copy the linux dotfiles
COPY linux/ /root/dotfiles/linux/

# Copy oh-my-posh config if it exists
COPY linux/.config/ohmyposh/ /root/dotfiles/linux/.config/ohmyposh/

# Remove default Ubuntu config files that conflict with stow
RUN rm -f /root/.bashrc /root/.bash_logout /root/.profile

# Apply stow configuration
RUN cd /root/dotfiles && stow linux

# Install Ruby and Node via mise (using stable versions)
# These can be overridden by mounting a .mise.toml or .tool-versions file
RUN mise install ruby@3.3 && \
    mise install node@22 && \
    mise use -g ruby@3.3 && \
    mise use -g node@22

# Set up bash as the default shell
SHELL ["/bin/bash", "-c"]

# Source bashrc on login
RUN echo 'source ~/.bashrc' >> /root/.bash_profile

# Set working directory to home
WORKDIR /root

# Default command starts an interactive bash shell
CMD ["/bin/bash", "-l"]
