DEFAULT_GOAL := help

ISO_DIR := "ISOs"
DISKS_DIR := "Disks"

ISO := "ubuntu-24.04-live-server-amd64"

FRESH_INSTALL := "fresh-install"
WORKING_DISK := "ubuntu"

.PHONY: help
help:
	echo "Options:"
	cat Makefile | grep "^.PHONY" | grep -v ".PHONY: help" | sed 's/^.*:/- make/'

.PHONY: disk
disk:
	qemu-img create -f qcow2 ${DISKS_DIR}/${FRESH_INSTALL}.qcow2 16G

.PHONY: install
install:
	qemu-system-x86_64 -enable-kvm -m 2048 -nic user,model=virtio -drive file=${DISKS_DIR}/${FRESH_INSTALL}.qcow2,media=disk,if=virtio -cdrom ${ISO_DIR}/${ISO}.iso
	chmod 400 ${DISKS_DIR}/${FRESH_INSTALL}

.PHONY: init
init:
	cp ${DISKS_DIR}/${FRESH_INSTALL}.qcow2 ${DISKS_DIR}/${WORKING_DISK}.qcow2
	chmod 600 ${DISKS_DIR}/${WORKING_DISK}.qcow2

.PHONY: run
run:
	qemu-system-x86_64 -enable-kvm -m 2048 -nic user,model=virtio -drive file=${DISKS_DIR}/${WORKING_DISK}.qcow2,media=disk,if=virtio 
