mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))
KDIR :=

.PHONY: all, PCIE, SDIO, USB, USB_BT

all: PCIE, SDIO, USB, USB_BT

PCIE:
	make -C $(KDIR) M=$(mkfile_dir)/src/PCIE/driver_fw/driver/aic8800/aic8800_fdrv

SDIO:
	make -C $(KDIR) M=$(mkfile_dir)/src/SDIO/driver_fw/driver/aic8800

USB:
	make -C $(KDIR) M=$(mkfile_dir)/src/USB/driver_fw/drivers/aic8800

USB_BT:
	make -C $(KDIR) M=$(mkfile_dir)/src/USB/driver_fw/drivers/aic_btusb
