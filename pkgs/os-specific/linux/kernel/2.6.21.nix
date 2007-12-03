args:
(import ./meta.nix)
( args //
  {
    version = "2.6.21.7";
    src_hash = { sha256 = "1c8ndsz35qd8vyng3xsxjjkjv5bnzyvc9b5vd85fz5v0bjp8hx50"; };

	systemPatches = [
      { name = "ext3cow";
        patch = ./linux-2.6.21.7-ext3cow_wouter.patch;
        extraConfig =  
	"CONFIG_EXT3COW_FS=m\n" +
	"CONFIG_EXT3COW_FS_XATTR=y\n" +
	"CONFIG_EXT3COW_FS_POSIX_ACL=y\n" +
	"CONFIG_EXT3COW_FS_SECURITY=y\n";
      }
      { name = "paravirt-nvidia";
        patch = ./2.6.20-paravirt-nvidia.patch;
      }
      { name = "skas-2.6.20-v9-pre9";
        patch = args.fetchurl {
          url = http://www.user-mode-linux.org/~blaisorblade/patches/skas3-2.6/skas-2.6.20-v9-pre9/skas-2.6.20-v9-pre9.patch.bz2;
          md5 = "02e619e5b3aaf0f9768f03ac42753e74";
        };
        extraConfig =
          "CONFIG_PROC_MM=y\n" +
          "# CONFIG_PROC_MM_DUMPABLE is not set\n";
      }
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = args.fetchurl {
          url = http://dev.gentoo.org/~dsd/genpatches/trunk/2.6.21/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "00s8074fzsly2zpir885zqkvq267qyzg6vhsn7n1z2v1z78avxd8";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
	];

    config = with args;
      if config != null then config else
      if userModeLinux then ./config-2.6.21-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.21-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.21-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }
)
