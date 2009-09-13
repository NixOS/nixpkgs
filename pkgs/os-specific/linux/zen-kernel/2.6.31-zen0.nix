a :  
let 
  s = import ./src-for-2.6.31-zen0.nix;
in 
(import ../kernel/generic.nix) (rec {
  inherit (a) stdenv fetchurl perl mktemp module_init_tools;

  src = a.builderDefs.fetchGitFromSrcInfo s;
  version = "2.6.31-zen0";
  config = "./kernel-config";
  features = {
    iwlwifi = true;
    zen = true;
  };

  extraMeta = {
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };

  preConfigure = '' 
    killOption () {
      sed -re 's/^('"$1"')=[ym]/# \1 is not set/' -i .config
    }
    setOptionMod () {
      sed -re 's/^# ('"$1"') is not set/\1=m/' -i .config
      sed -re "1i$1=m" -i .config
    }
    setOptionYes () {
      sed -re 's/^# ('"$1"') is not set/\1=y/' -i .config
      sed -re "1i$1=y" -i .config
    }

    make allmodconfig

    killOption CONFIG_CMDLINE_OVERRIDE

    killOption CONFIG_IMA
    killOption 'CONFIG_.*_DEBUG.*'
    killOption 'CONFIG_DEBUG.*'
    killOption CONFIG_AUDIT_ARCH
    
    killOption CONFIG_KERNEL_BZIP2
    killOption CONFIG_KERNEL_LZMA
    setOptionYes CONFIG_KERNEL_GZIP

    killOption CONFIG_TASKSTATS
    killOption CONFIG_PREEMPT_NONE
    setOptionYes CONFIG_PREEMPT_VOLUNTARY

    killOption CONFIG_SLQB
    killOption CONFIG_SLQB_ALLOCATOR
    setOptionYes CONFIG_SLUB_ALLOCATOR
    setOptionYes CONFIG_SLUB
    killOption CONFIG_ACPI_CUSTOM_DSDT_INITRD
    killOption CONFIG_DEVTMPFS
    killOption CONFIG_DEVTMPFS_MOUNT

    cp .config ${config}
  '';
})
