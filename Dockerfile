FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set locale
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Basic deps + Ruby/Node build requirements
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    build-essential \
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

# mise
RUN curl https://mise.run | sh
ENV PATH="/root/.local/bin:${PATH}"

# oh-my-posh
RUN curl -s https://ohmyposh.dev/install.sh | bash -s

# Stage the dotfiles repo at /root/dotfiles. The test runner mounts the
# linux/ tree on top of this so edits are picked up live.
WORKDIR /root/dotfiles
COPY linux/   /root/dotfiles/linux/
COPY scripts/ /root/dotfiles/scripts/

# Wipe Ubuntu defaults so install.sh has a clean target
RUN rm -f /root/.bashrc /root/.bash_logout /root/.profile

# Run the new copy-based installer
RUN bash /root/dotfiles/scripts/install.sh

# Ruby + Node via mise
RUN mise install ruby@3.3 && \
    mise install node@22 && \
    mise use -g ruby@3.3 && \
    mise use -g node@22

SHELL ["/bin/bash", "-c"]

WORKDIR /root
CMD ["/bin/bash", "-l"]
