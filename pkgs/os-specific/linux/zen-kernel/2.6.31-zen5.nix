a :  
let 
  s = import ./src-for-2.6.31-zen5.nix;
  in 
(import ../kernel/generic.nix) (rec {
  inherit (a) stdenv fetchurl perl mktemp module_init_tools platform;

  uboot = if (platform.name == "sheevaplug") then
    platform.uboot else null;

  src = a.builderDefs.fetchGitFromSrcInfo s;
  version = "2.6.31-zen5";
  config = "./kernel-config";
  features = {
    iwlwifi = true;
    zen = true;
    fbConDecor = if (platform.name == "pc") then true else false;
    aufs = true;
  };

  extraMeta = {
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };

  configFunctions = '' 
    killOption () {
      sed -re 's/^('"$1"')=.*/# \1 is not set/' -i .config
    }
    setOptionVal () {
      sed -re 's/^('"$1"')=.*/\1='"$2"'/' -i .config
      sed -re 's/^# ('"$1"') is not set/\1='"$2"'/' -i .config
      sed -re "1i$1=$2" -i .config
    }
    setOptionMod () {
      setOptionVal "$1" m
    }
    setOptionYes () {
      setOptionVal "$1" y
    }
  '';


  configurePC = ''
    make allmodconfig

    killOption CONFIG_CMDLINE_OVERRIDE

    killOption 'CONFIG_.*_DEBUG.*'
    killOption 'CONFIG_DEBUG.*'
    killOption CONFIG_AUDIT_ARCH
    killOption CONFIG_PERF_COUNTERS
    killOption 'CONFIG_GCOV.*'
    killOption 'CONFIG_KGDB.*'
    killOption 'CONFIG_.*_TEST'
    killOption CONFIG_TASKSTATS

    killOption CONFIG_SLQB
    killOption CONFIG_SLQB_ALLOCATOR
    setOptionYes CONFIG_SLUB_ALLOCATOR
    setOptionYes CONFIG_SLUB
    killOption CONFIG_ACPI_CUSTOM_DSDT_INITRD
    killOption CONFIG_DEVTMPFS
    killOption CONFIG_DEVTMPFS_MOUNT

    killOption CONFIG_IMA
  '' +
  ''
    killOption CONFIG_USB_OTG_BLACKLIST_HUB
  ''+
  ''
    killOption CONFIG_KERNEL_BZIP2
    killOption CONFIG_KERNEL_LZMA
    setOptionYes CONFIG_KERNEL_GZIP
  ''+
  ''
    killOption CONFIG_FB_TILEBLITTING
    killOption CONFIG_FB_S3
    killOption CONFIG_FB_VT8623
    killOption CONFIG_FB_ARK
    setOptionYes CONFIG_FRAMEBUFFER_CONSOLE
    setOptionYes CONFIG_FB
    make oldconfig
    setOptionYes CONFIG_FB_CON_DECOR
    setOptionYes CONFIG_FB_VESA
  ''+
  ''
    killOption CONFIG_PREEMPT_NONE
    setOptionYes CONFIG_PREEMPT_VOLUNTARY
  ''+
  ''
    killOption CONFIG_PRAMFS
  ''+
  (if a.lib.attrByPath ["ckSched"] false a then ''
    killOption CONFIG_CPU_CFS
    setOptionYes CONFIG_CPU_BFS
    killOption CONFIG_NO_HZ
    killOption CONFIG_HZ_1000
    setOptionYes CONFIG_HZ_250
    setOptionVal CONFIG_HZ 250
  ''else "") +
  ''
    cp .config ${config}
  '';

  configureBaseSheevaplug = '' 
    ARCH=arm make kirkwood_defconfig
  '';

  configureBaseVersatileARM = '' 
    ARCH=arm make versatile_defconfig

    setOptionYes CONFIG_IP_PNP_DHCP
    setOptionYes CONFIG_TUN
    # This versatile arm is for the sheevaplug compatibility, so, EABI
    setOptionYes CONFIG_AEABI
    setOptionYes CONFIG_TMPFS
    # For the qemu block device 'hda' to work
    setOptionYes CONFIG_PCI
    setOptionYes CONFIG_SCSI
    setOptionYes CONFIG_BLK_DEV_SD
    setOptionYes CONFIG_SCSI_SYM53C8XX_2
  '';

  configureARM = '' 
    killOption CONFIG_CMDLINE_OVERRIDE

    killOption 'CONFIG_.*_DEBUG.*'
    killOption 'CONFIG_DEBUG.*'
    killOption CONFIG_AUDIT_ARCH
    killOption CONFIG_PERF_COUNTERS
    killOption 'CONFIG_GCOV.*'
    killOption 'CONFIG_KGDB.*'
    killOption 'CONFIG_.*_TEST'
    killOption CONFIG_TASKSTATS

    killOption CONFIG_SLQB
    killOption CONFIG_SLQB_ALLOCATOR
    setOptionYes CONFIG_SLUB_ALLOCATOR
    setOptionYes CONFIG_SLUB
    killOption CONFIG_ACPI_CUSTOM_DSDT_INITRD
    killOption CONFIG_DEVTMPFS
    killOption CONFIG_DEVTMPFS_MOUNT

    killOption CONFIG_IMA
  '' +
  ''
    killOption CONFIG_USB_OTG_BLACKLIST_HUB
  ''+
  ''
    killOption CONFIG_KERNEL_BZIP2
    killOption CONFIG_KERNEL_LZMA
    setOptionYes CONFIG_KERNEL_GZIP
  ''+
  ''
    killOption CONFIG_FB_TILEBLITTING
    killOption CONFIG_FB_S3
    killOption CONFIG_FB_VT8623
    killOption CONFIG_FB_ARK
    killOption CONFIG_FRAMEBUFFER_CONSOLE
    killOption CONFIG_FB
    make oldconfig
    killOption CONFIG_FB_CON_DECOR
    killOption CONFIG_FB_VESA
  ''+
  ''
    killOption CONFIG_PREEMPT_NONE
    setOptionYes CONFIG_PREEMPT_VOLUNTARY
  ''+
  ''
    killOption CONFIG_PRAMFS
  ''+
  ''
    setOptionYes CONFIG_MTD_UBI
    setOptionYes CONFIG_REISERFS_FS
    setOptionYes CONFIG_FUSE_FS
    setOptionYes CONFIG_ISO9660_FS
  ''+
  (if a.lib.attrByPath ["ckSched"] false a then ''
    killOption CONFIG_CPU_CFS
    setOptionYes CONFIG_CPU_BFS
    killOption CONFIG_NO_HZ
    killOption CONFIG_HZ_1000
    setOptionYes CONFIG_HZ_250
    setOptionVal CONFIG_HZ 250
  ''else "") +
  ''
    cp .config ${config}
  '';


  preConfigure = configFunctions +
    (if (platform.name == "pc") then
       (configureBaseSheevaplug + configureARM)
    else if (platform.name == "sheevaplug") then
       (configureBaseSheevaplug + configureARM)
    else if (platform.name == "versatileARM") then
       (configureBaseVersatileARM + configureARM)
    else throw "platform not supported"
    );
})
