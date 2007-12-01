args:
(import ./meta.nix)
( args //
  {
    version = "2.6.22.10";
    src_hash = { sha256 = "0kh196qzm54mvnbrdr9s2q86l9yn2321gnsl5xq44ai2idqp044g"; };

	systemPatches = [
      { name = "paravirt-nvidia";
        patch = ../os-specific/linux/kernel/2.6.22-paravirt-nvidia.patch;
      }
      { name = "fbsplash-0.9.2-r5-2.6.21";
        patch = fetchurl {
          url = http://dev.gentoo.org/~dsd/genpatches/trunk/2.6.22/4200_fbsplash-0.9.2-r5.patch;
          sha256 = "0822wwlf2dqsap5qslnnp0yl1nbvvvb76l73w2dd8zsyn0bqg3px";
        };
        extraConfig = "CONFIG_FB_SPLASH=y";
      }
	];

    config = with args;
      if kernelConfig != null then kernelConfig else
      if userModeLinux then ./config-2.6.22-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.22-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.22-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }
)
