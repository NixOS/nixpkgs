args:
(import ./meta.nix)
( args //
  {
    version = "2.6.20.12";
    src_hash = { sha256 = "1s7vdpg2897q5pcyxxypqcnibwpbdawbimkf3pngmahj8wr9c03x"; };

	systemPatches = [
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
      { name = "fbsplash-0.9.2-r5-2.6.20-rc6";
        patch = args.fetchurl {
          url = http://dev.gentoo.org/~spock/projects/gensplash/archive/fbsplash-0.9.2-r5-2.6.20-rc6.patch;
          sha256 = "11v4f85f4jnh9sbhqcyn47krb7l1czgzjw3w8wgbq14jm0sp9294";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
	];

    config = with args;
      if config != null then config else
      if userModeLinux then ./config-2.6.20-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.20-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.20-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }
)
