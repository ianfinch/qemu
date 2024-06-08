ISO_DIR := ISOs
DISKS_DIR := Disks

ISO := ubuntu-24.04-live-server-amd64

FRESH_INSTALL := fresh-install
WORKING_DISK := ubuntu

run: ${DISKS_DIR}/${WORKING_DISK}.qcow2
	qemu-system-x86_64 -enable-kvm -m 2048 -nic user,hostfwd=tcp::2222-:22 -drive file=${DISKS_DIR}/${WORKING_DISK}.qcow2,media=disk,if=virtio 

${DISKS_DIR}/${WORKING_DISK}.qcow2: ${DISKS_DIR}/${FRESH_INSTALL}.qcow2
	cp ${DISKS_DIR}/${FRESH_INSTALL}.qcow2 ${DISKS_DIR}/${WORKING_DISK}.qcow2
	chmod 600 ${DISKS_DIR}/${WORKING_DISK}.qcow2

${DISKS_DIR}/${FRESH_INSTALL}:
	qemu-img create -f qcow2 ${DISKS_DIR}/${FRESH_INSTALL}.qcow2 16G
	qemu-system-x86_64 -enable-kvm -m 2048 -nic user,model=virtio -drive file=${DISKS_DIR}/${FRESH_INSTALL}.qcow2,media=disk,if=virtio -cdrom ${ISO_DIR}/${ISO}.iso
	chmod 400 ${DISKS_DIR}/${FRESH_INSTALL}

reset:
	rm ${DISKS_DIR}/${WORKING_DISK}.qcow2

clean:
	rm ${DISKS_DIR}/${FRESH_INSTALL}.qcow2
	rm ${DISKS_DIR}/${WORKING_DISK}.qcow2
