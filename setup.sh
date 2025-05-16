#!/usr/bin/env bash

BUILD_ROOT="$PWD"
VENDOR_ROOT="${BUILD_ROOT}/LA.UM.8.13.r1"

function sync_repo {
    mkdir -p "$1" && cd "$1"
    echo "[+] Changed directory to $1."

    if repo init --depth=1 -q -u https://github.com/QRD-Development/SM7250.LA.1.0.1_BSP_Sync.git -b LA.UM.8.13.r1 -m "$2"; then
        echo "[+] Repo initialized successfully."
    else
        echo "[-] Error: Failed to initialize repo."
        exit 1
    fi

    echo "[+] Starting repo sync..."
    if schedtool -B -e ionice -n 0 repo sync -q -c --force-sync --optimized-fetch --no-tags --retry-fetches=5 -j"$(nproc --all)"; then
        echo "[+] Repo synced successfully."
    else
        echo "[-] Error: Failed to sync repo."
        exit 1
    fi
}

sync_repo "$VENDOR_ROOT" "AU_LINUX_ANDROID_LA.UM.8.13.R1.10.00.00.571.085.xml"

cd "$BUILD_ROOT"
echo "[+] Successfully returned to the build root."