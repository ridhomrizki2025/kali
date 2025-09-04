#!/bin/bash
# setup_buildozer_kali.sh
# Script fix untuk Kali Linux v1.1 (repo moto) + buildozer python3

echo "[*] Backup sources.list lama..."
cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "[*] Ganti sources.list ke Debian archive (karena repo lama sudah mati)..."
cat > /etc/apt/sources.list <<EOF
deb http://archive.debian.org/debian jessie main contrib non-free
deb http://archive.debian.org/debian-security jessie/updates main contrib non-free
EOF

echo "[*] Update package list..."
apt-get -o Acquire::Check-Valid-Until=false update

echo "[*] Install Python3, pip3, dan tool dasar..."
apt-get install -y python3 python3-pip python3-setuptools python3-venv git unzip openjdk-8-jdk

echo "[*] Set python3 sebagai default..."
update-alternatives --install /usr/bin/python python /usr/bin/python3 2
update-alternatives --set python /usr/bin/python3

echo "[*] Upgrade pip dan install buildozer + cython..."
pip3 install --upgrade pip
pip3 install cython buildozer kivy

echo "[*] Hapus cache buildozer lama (biar tidak pakai python2)..."
rm -rf ~/.buildozer

echo "[*] Instalasi selesai!"
echo "Sekarang kamu bisa coba: buildozer init && buildozer android debug"
