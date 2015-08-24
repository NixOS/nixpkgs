{stdenv, fetchurl, kernel, ncurses, fxload}:

let

  # A patch to fix A/V sync, and to allow video to be played
  # (e.g. using MPlayer) while the AVI is being recorded.
  gorecordAV = fetchurl {
    url = http://colabti.org/convertx/patch-av-aviheader.diff;
    sha256 = "04qk58qigzwfdnn3mr3pg28qx4r89nlzdhgkvfipz36bsny23r50";
  };

in   

stdenv.mkDerivation {
  name = "wis-go7007-0.9.8-${kernel.version}";

  src = fetchurl {
    url = http://gentoo.osuosl.org/distfiles/wis-go7007-linux-0.9.8.tar.bz2;
    sha256 = "06lvlz42c5msvwc081p8vjcbv8qq1j1g1myxhh27xi8zi06n1mzg";
  };

  patches = map fetchurl [
    { url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/media-tv/wis-go7007/files/wis-go7007-0.9.8-kernel-2.6.17.diff?rev=1.1";
      sha256 = "0cizbg82fdl5byhvpkdx64qa02xcahdyddi2l2jn95sxab28a5yg";
    }
    { url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/media-tv/wis-go7007/files/wis-go7007-0.9.8-fix-udev.diff?rev=1.2";
      sha256 = "1985lcb7gh5zsf3lm0b43zd6q0cb9q4z376n9q060bh99yw6m0w1";
    }
    { url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/media-tv/wis-go7007/files/snd.patch?rev=1.1";
      sha256 = "0a6dz1l16pz1fk77s3awxh635cacbivfcfnd1carbx5jp2gq3jna";
    }
    { url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/media-tv/wis-go7007/files/wis-go7007-2.6.26-nopage.diff?rev=1.1";
      sha256 = "18ks6dm9nnliab9ncgxx5nhw528vhwg83byps8wjsbadd3wzwym3";
    }
    { url = http://home.comcast.net/~bender647/go7007/wis-go7007-2.6.24-no_algo_control.diff;
      sha256 = "1a7jkcsnzagir3wpsj60pjrr9wgfaqq21jlmq6s0qg9hqg4nzbvf";
    }
  ] ++ [
    # http://nikosapi.org/wiki/index.php/WIS_Go7007_Linux_driver#wis-streamer_fails_to_find_the_ALSA_audio_node_and_emulated_OSS_device_node
    ./alsa.patch
  ];

  buildInputs = [ncurses];

  postPatch = ''
    (cd apps && patch < ${gorecordAV}) || false
  '';

  preBuild = ''
    includeDir=$TMPDIR/scratch
    substituteInPlace Makefile \
        --replace '$(DESTDIR)$(KSRC)/include/linux' $includeDir \
        --replace '$(DESTDIR)$(FIRMWARE_DIR)' '$(FIRMWARE_DIR)'
    mkdir -p $includeDir
    mkdir -p $out/etc/hotplug/usb
    mkdir -p $out/etc/udev/rules.d
 
    makeFlagsArray=(KERNELSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source \
        FIRMWARE_DIR=$out/lib/firmware FXLOAD=${fxload}/sbin/fxload \
        DESTDIR=$out SKIP_DEPMOD=1 \
        USE_UDEV=y)
  ''; # */

  postInstall = ''
    mkdir -p $out/bin
    cp apps/gorecord apps/modet $out/bin/
  '';

  meta = {
    description = "Kernel module for the Micronas GO7007, used in a number of USB TV devices";
    homepage = http://oss.wischip.com/;
    broken = true;
  };
}
