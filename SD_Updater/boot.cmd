# OpenIPC automatic update script for Ingenic T23 via SD-card

# Set serverip to a dummy value just to prevent tftp timeouts if something goes wrong
setenv serverip 192.168.1.254

echo "=================================================="
echo "--- OpenIPC SD-Card Auto-Update Script Started ---"
echo "=================================================="

# 1. Update Kernel if uImage.t23 exists on the SD card
if fatload mmc 0 ${baseaddr} uImage.t23; then
    echo "--- Found uImage.t23 on SD card. Flashing Kernel... ---"
    sf probe 0
    echo "--- Erasing Kernel sector... ---"
    sf erase ${kernaddr} ${kernsize}
    echo "--- Writing Kernel to SPI Flash... ---"
    sf write ${baseaddr} ${kernaddr} ${filesize}
    echo "--- Kernel update successful! ---"
else
    echo "--- No uImage.t23 found on SD card. Skipping Kernel. ---"
fi

# 2. Update RootFS if rootfs.squashfs.t23 exists on the SD card
if fatload mmc 0 ${baseaddr} rootfs.squashfs.t23; then
    echo "--- Found rootfs.squashfs.t23 on SD card. Flashing RootFS... ---"
    sf probe 0
    echo "--- Erasing RootFS sector... ---"
    sf erase ${rootaddr} ${rootsize}
    echo "--- Writing RootFS to SPI Flash... ---"
    sf write ${baseaddr} ${rootaddr} ${filesize}
    echo "--- RootFS update successful! ---"
else
    echo "--- No rootfs.squashfs.t23 found on SD card. Skipping RootFS. ---"
fi

echo "=================================================="
echo "--- Update process finished. Booting Linux...   ---"
echo "=================================================="

# Proceed to standard boot from SPI Flash
setenv bootcmd ${cmdnor}
sf probe 0
run bootcmd
