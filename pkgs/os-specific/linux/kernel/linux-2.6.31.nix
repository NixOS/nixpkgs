args @ {stdenv, fetchurl, userModeLinux ? false, oldI686 ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  let
    baseVersion = "2.6.31"; 
  in

  rec {
    version = "2.6.31";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${baseVersion}.tar.bz2";
      sha256 = "04im1rk53j1im1q8i6pl6qn75zd63dg51dxhq8cfxdsxp3vq7k8a";
    };

    features = {
      iwlwifi = true;
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
        killOption CONFIG_PERF_COUNTERS
        killOption 'CONFIG_GCOV.*'
        killOption 'CONFIG_KGDB.*'
        killOption 'CONFIG_.*_TEST'
        
        killOption CONFIG_KERNEL_BZIP2
        killOption CONFIG_KERNEL_LZMA
        setOptionYes CONFIG_KERNEL_GZIP
        
        killOption CONFIG_TASKSTATS
        killOption CONFIG_PREEMPT_NONE
        setOptionYes CONFIG_PREEMPT_VOLUNTARY
        
        cp .config ${config}
    '';

    config = "./kernel-config";
  }

  // args
)
