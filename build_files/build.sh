#!/bin/bash

set -ouex pipefail

### Install packages

# Setup COPR repos

dnf5 -y copr enable yalter/niri-git
dnf5 -y copr enable quadratech188/cmark-gfm
dnf5 config-manager setopt terra.enabled=1 terra-extras.enabled=1

# Install Niri

echo "priority=1" | tee -a /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:yalter:niri-git.repo
dnf5 -y --enablerepo copr:copr.fedorainfracloud.org:yalter:niri-git \
    install --setopt=install_weak_deps=False \
    niri

# Install Noctalia (in terra repo)

dnf5 -y install --setopt=install_weak_deps=False noctalia-shell

# Install Vicinae

# dnf5 -y install \
#     qt6-qtbase-devel \
#     qt6-qtsvg-devel \
#     qt6-qtbase-private-devel \
#     qt6-qtwayland-devel \
#     layer-shell-qt-devel \
#     libqalculate-devel \
#     minizip-devel \
#     rapidfuzz-cpp-devel \
#     qtkeychain-qt6-devel \
#     openssl-devel \
#     wayland-devel \
#     glibc-static \
#     libstdc++-static \
#     zlib-devel \
#     zlib-static \
#     abseil-cpp-devel \
#     protobuf-devel \
#     libicu-devel \
#     cmark-gfm-devel \
#     ninja-build \
#     nodejs-npm
# git clone https://github.com/vicinaehq/vicinae.git && cd vicinae
# make release
# sudo make install

dnf5 -y install udiskie

# Disable COPR repos

dnf5 -y copr disable yalter/niri-git
dnf5 -y copr disable quadratech188/cmark-gfm
dnf5 config-manager setopt terra.enabled=0 terra-extras.enabled=0

### Example for enabling a System Unit File

add_wants_niri() {
    sed -i "s/\[Unit\]/\[Unit\]\nWants=$1/" "/usr/lib/systemd/user/niri.service"
}
# add_wants_niri udiskie.service
cat /usr/lib/systemd/user/niri.service

# systemctl enable podman.socket
systemctl enable --global noctalia.service
# systemctl enable --global udiskie.service

### Misc tweaks

HOME_URL="https://github.com/sand-head/powerful-bob"
echo "powerful-bob" | tee "/etc/hostname"

# OS Release File (changed in order with upstream)
sed -i -f - /usr/lib/os-release <<EOF
s|^NAME=.*|NAME=\"Powerful Bob\"|
s|^PRETTY_NAME=.*|PRETTY_NAME=\"Powerful Bob\"|
s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"Apollo\"|
s|^VARIANT_ID=.*|VARIANT_ID=""|
s|^HOME_URL=.*|HOME_URL=\"${HOME_URL}\"|
s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"${HOME_URL}/issues\"|
s|^SUPPORT_URL=.*|SUPPORT_URL=\"${HOME_URL}/issues\"|
s|^CPE_NAME=\".*\"|CPE_NAME=\"cpe:/o:sand-head:powerful-bob\"|
s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"${HOME_URL}\"|
s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME="powerful-bob"|