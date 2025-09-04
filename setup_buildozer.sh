#!/bin/bash
# Setup Buildozer di Kali Linux 2019.4 dengan SDK, NDK, Gradle, dan API level 29
# Tested untuk Python3, OpenJDK 8, Cython 0.29.19

set -e

echo "=== [1/8] Update sistem ==="
sudo apt update && sudo apt upgrade -y

echo "=== [2/8] Install dependensi utama ==="
sudo apt install -y python3 python3-pip git zip unzip wget curl \
    openjdk-8-jdk build-essential python3-dev python3-venv \
    libncurses5 libstdc++6 libffi-dev libssl-dev \
    zlib1g-dev libsqlite3-dev adb

echo "=== [3/8] Set JAVA_HOME (OpenJDK 8) ==="
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
if [ -d "$JAVA_HOME" ]; then
    if ! grep -q "JAVA_HOME" ~/.bashrc; then
        echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
        echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
    fi
    export JAVA_HOME=$JAVA_HOME
    export PATH=$JAVA_HOME/bin:$PATH
else
    echo "[WARNING] Java 8 tidak ditemukan!"
fi

echo "=== [4/8] Upgrade pip & install buildozer + cython ==="
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install Cython==0.29.19 buildozer virtualenv

echo "=== [5/8] Buat virtualenv buildozer (opsional tapi disarankan) ==="
if [ ! -d "$HOME/buildozer_venv" ]; then
    python3 -m venv $HOME/buildozer_venv
    source $HOME/buildozer_venv/bin/activate
    pip install --upgrade pip
    pip install Cython==0.29.19 buildozer
else
    source $HOME/buildozer_venv/bin/activate
fi

echo "=== [6/8] Siapkan direktori buildozer android platform ==="
ANDROID_DIR=$HOME/.buildozer/android/platform
mkdir -p $ANDROID_DIR

# Versi stabil yang cocok untuk buildozer lawas
SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip"
NDK_URL="https://dl.google.com/android/repository/android-ndk-r19c-linux-x86_64.zip"
GRADLE_URL="https://services.gradle.org/distributions/gradle-6.9-bin.zip"

cd $ANDROID_DIR

# Download SDK
if [ ! -d "$ANDROID_DIR/android-sdk" ]; then
    echo "=== Download Android SDK ==="
    wget -q $SDK_URL -O sdk.zip
    mkdir -p android-sdk/cmdline-tools
    unzip sdk.zip -d android-sdk/cmdline-tools
    mv android-sdk/cmdline-tools/cmdline-tools android-sdk/cmdline-tools/latest
    rm sdk.zip
    echo "[OK] Android SDK terpasang"
fi

# Download NDK
if [ ! -d "$ANDROID_DIR/android-ndk-r19c" ]; then
    echo "=== Download Android NDK r19c ==="
    wget -q $NDK_URL -O ndk.zip
    unzip ndk.zip
    rm ndk.zip
    echo "[OK] Android NDK r19c terpasang"
fi

# Download Gradle
if [ ! -d "$ANDROID_DIR/gradle-6.9" ]; then
    echo "=== Download Gradle 6.9 ==="
    wget -q $GRADLE_URL -O gradle.zip
    unzip gradle.zip
    rm gradle.zip
    echo "[OK] Gradle 6.9 terpasang"
fi

echo "=== [7/8] Install Android API level 29 ==="
SDKMANAGER=$ANDROID_DIR/android-sdk/cmdline-tools/latest/bin/sdkmanager
yes | $SDKMANAGER --sdk_root=$ANDROID_DIR/android-sdk "platforms;android-29" "platform-tools" "build-tools;29.0.3"

echo "=== [8/8] Cek instalasi buildozer ==="
if command -v buildozer >/dev/null 2>&1; then
    echo "[OK] Buildozer siap dipakai."
else
    echo "[ERROR] Buildozer tidak ditemukan. Aktifkan venv dengan:"
    echo "source ~/buildozer_venv/bin/activate"
fi

echo "=== Selesai! ==="
echo "Cara pakai:"
echo "  mkdir myapp && cd myapp"
echo "  buildozer init"
echo "  buildozer -v android debug"
