args:
(import ./meta.nix)
( args //
  {
    version = "2.6.23.1";
    src_hash = { sha256 = "0737g83h7jbrlss8782b17mhc3nfn8qfbh5s71flz8pjxmbbmg1m"; };

	systemPatches = [
      { name = "paravirt-nvidia";
        patch = ./2.6.22-paravirt-nvidia.patch;
      }
      { # resume with resume=swap:/dev/xx
        name = "tux on ice"; # (swsusp2)
        patch = args.fetchurl {
          url = "http://www.tuxonice.net/downloads/all/tuxonice-3.0-rc2-for-2.6.23.1.patch.bz2";
          sha256 = "ef86267b6f3d7e309221f5173a881afae1dfa57418be5b3963f2380b0633ca1a";
        };
        extraConfig = "
          CONFIG_SUSPEND2=y
          CONFIG_SUSPEND2_FILE=y
          CONFIG_SUSPEND2_SWAP=y
          CONFIG_CRYPTO_LZF=y
        ";
      }
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = args.fetchurl {
          url = http://dev.gentoo.org/~dsd/genpatches/trunk/2.6.22/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "0822wwlf2dqsap5qslnnp0yl1nbvvvb76l73w2dd8zsyn0bqg3px";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
	];

    config = with args;
      if kernelConfig != null then kernelConfig else
      if userModeLinux then ./config-2.6.23.1-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.23.1-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.23.1-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }
)
