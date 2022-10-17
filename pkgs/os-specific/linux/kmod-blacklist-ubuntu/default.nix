{ lib, stdenv, fetchurl }:

let
  version = "28-1ubuntu4"; # impish 2021-06-24

in stdenv.mkDerivation {
  pname = "kmod-blacklist";
  inherit version;

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/kmod_${version}.debian.tar.xz";
    sha256 = "sha256-K8tWpaLmCm3Jcxw3OZ+D7Koiug7epooRn1YMfqjGAiw=";
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
      --replace "blacklist bochs-drm" "" \
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
