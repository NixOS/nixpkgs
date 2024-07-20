{ lib, stdenv, fetchurl }:

let
  version = "30+20230519-1ubuntu3"; # mantic 2023-08-26

in stdenv.mkDerivation {
  pname = "kmod-blacklist";
  inherit version;

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/kmod_${version}.debian.tar.xz";
    hash = "sha256-VGw1/rUjl9/j6026ut0dvC0/8maAAz8umb0D3YGf8p4=";
  };

  installPhase = ''
    mkdir "$out"
    for f in modprobe.d/*.conf; do
      echo "''\n''\n## file: "`basename "$f"`"''\n''\n" >> "$out"/modprobe.conf
      cat "$f" >> "$out"/modprobe.conf
      # https://bugs.launchpad.net/ubuntu/+source/kmod/+bug/1475945
      sed -i '/^blacklist i2c_i801/d' $out/modprobe.conf
    done

    substituteInPlace "$out"/modprobe.conf \
      --replace /sbin/lsmod /run/booted-system/sw/bin/lsmod \
      --replace /sbin/rmmod /run/booted-system/sw/bin/rmmod \
      --replace /sbin/modprobe /run/booted-system/sw/bin/modprobe \
      --replace " grep " " /run/booted-system/sw/bin/grep " \
      --replace " xargs " " /run/booted-system/sw/bin/xargs "
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/ubuntu/+source/kmod";
    description = "Linux kernel module blacklists from Ubuntu";
    platforms = platforms.linux;
    license = with licenses; [ gpl2Plus lgpl21Plus ];
  };
}
