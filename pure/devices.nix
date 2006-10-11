[
  { id = "net-dev-1";
    comment = "Broadcom Corporation NetXtreme BCM5751 Gigabit Ethernet PCI Express";
    location = {
      busId = "pci-0000:02:00.0";
      macAddr = "00:14:22:bc:68:51";
      prefer = "macAddr"; # i.e., don't care if busId changes
    };
    extraModules = []; # tg3
  }

  { id = "keyboard-1";
    comment = "Dell Computer Corp. SK-8125 Keyboard";
    location = {
      busId = "usb-003-003";
    };
    extraModules = [];
  }
  
]
