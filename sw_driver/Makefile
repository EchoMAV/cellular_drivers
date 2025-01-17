obj-m += cdc_mbim.o cdc-wdm.o qcserial.o usb_wwan.o qmi_wwan.o

KERNEL_RELEASE := $(shell uname -r)
KDIR           := /lib/modules/$(KERNEL_RELEASE)/build

all:
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules

install:
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules_install

clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean

.PHONY: all install clean