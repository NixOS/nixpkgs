args:
(import ./meta.nix)
( args //
  {
    version = "2.6.23.16";
    src_hash = { sha256 = "0drk3981rl5j16s6amb63lai9kpi0vf0kr6avhpd9nikj27bsa83"; };

	systemPatches = [
      /*{ # resume with resume=swap:/dev/xx
        name = "tux on ice"; # (swsusp2)
        patch = args.fetchurl {
          url = "http://www.tuxonice.net/downloads/all/tuxonice-3.0-rc3-for-2.6.23.9.patch.bz2";
          sha256 = "16f61cn0mdi7yklhdx4isi7c85843fzxq2cifd05cpsl6x6ilrfk";
        };
        extraConfig = "
          CONFIG_SUSPEND2=y
          CONFIG_SUSPEND2_FILE=y
          CONFIG_SUSPEND2_SWAP=y
          CONFIG_CRYPTO_LZF=y
        ";
      }*/
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = args.fetchurl {
          url = http://dev.gentoo.org/~dsd/genpatches/trunk/2.6.22/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "0822wwlf2dqsap5qslnnp0yl1nbvvvb76l73w2dd8zsyn0bqg3px";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
	];

    config = with args;
      if config != null then config else
      if userModeLinux then ./config-2.6.23-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.23-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.23-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }
)

