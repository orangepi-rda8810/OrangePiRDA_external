# default values
setenv verbosity "8"
setenv init_modem "yes"

if test "${boot_device}" = "mmc"; then

	setenv rootdev "/dev/mmcblk0p2"
	setenv rootfstype "ext4"

	if ext2load mmc 0:1 ${load_addr} armbianEnv.txt; then
		env import -t ${load_addr} ${filesize}
	fi

	setenv bootargs "root=${rootdev} rootwait rootfstype=${rootfstype} console=ttyS0,921600 panic=10 consoleblank=0 loglevel=${verbosity} ${extraargs} ${extraboardargs}"

	ext2load mmc 0:1 ${initrd_addr} uInitrd
	ext2load mmc 0:1 ${kernel_addr} zImage
	ext2load mmc 0:1 ${modem_addr} modem.bin
else
	echo "NAND boot is not implemented yet"
fi

if test "${init_modem}" = "yes"; then
	mdcom_loadm ${modem_addr}
	mdcom_check 1
fi

bootz ${kernel_addr} ${initrd_addr}

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr
