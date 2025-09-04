#!/bin/bash
# fix_repo_keyring_kali.sh
# Perbaiki repo expired key di Kali Linux 1.1 (Moto, based on Debian Jessie)

echo "[*] Backup sources.list lama..."
cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "[*] Set sources.list ke Debian Jessie archive..."
cat > /etc/apt/sources.list <<EOF
deb http://archive.debian.org/debian jessie main contrib non-free
deb http://archive.debian.org/debian-security jessie/updates main contrib non-free
EOF

echo "[*] Download debian-archive-keyring terbaru..."
wget http://ftp.debian.org/debian/pool/main/d/debian-archive-keyring/debian-archive-keyring_2019.1_all.deb -O /tmp/debian-archive-keyring.deb

echo "[*] Install keyring baru..."
dpkg -i /tmp/debian-archive-keyring.deb

echo "[*] Update package list (disable expired check)..."
apt-get -o Acquire::Check-Valid-Until=false update

echo "[*] Selesai! Sekarang repo bisa dipakai tanpa error KEYEXPIRED."
