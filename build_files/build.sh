#!/bin/bash

set -ouex pipefail

### Install packages

# Install Niri

dnf5 -y copr enable yalter/niri-git
echo "priority=1" | tee -a /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:yalter:niri-git.repo
dnf -y --enablerepo copr:copr.fedorainfracloud.org:yalter:niri-git \
    install --setopt=install_weak_deps=False \
    niri
dnf5 -y copr disable yalter/niri-git

# Install Noctalia (in terra repo)

dnf5 -y install --setopt=install_weak_deps=False noctalia-shell

#### Example for enabling a System Unit File

# systemctl enable podman.socket
