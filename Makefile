.POSIX:
SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: build
build:
	packer build -on-error=ask .

.PHONY: test
test:
	vagrant up

.PHONY: install
install:
	vagrant box add 'stm32_tools' ./artifacts/qemu/stm32_tools_*.box

.PHONY: uninstall
uninstall:
	vagrant box remove 'stm32_tools'

.PHONY: cleanup
cleanup:
	vagrant destroy -f
	vagrant box remove ./artifacts/qemu/jammy.box
	rm -rf artifacts
	rm -rf .vagrant
