{ stdenv, fetchurl, gnugrep, findutils }:
let
  version = "3ubuntu1"; # Saucy
in
stdenv.mkDerivation {
  name = "kmod-blacklist-${version}";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/kmod_9-${version}.debian.tar.gz";
    sha256 = "0h6h0zw2490iqj9xa2sz4309jyfmcc50jdvkhxa1nw90npxglp67";
  };

  installPhase = ''
    mkdir "$out"
    for f in modprobe.d/*.conf; do
      echo "''\n''\n## file: "`basename "$f"`"''\n''\n" >> "$out"/modprobe.conf
      cat "$f" >> "$out"/modprobe.conf
    done

    substituteInPlace "$out"/modprobe.conf \
      --replace /sbin/lsmod /run/booted-system/sw/bin/lsmod \
      --replace /sbin/rmmod /run/booted-system/sw/bin/rmmod \
      --replace /sbin/modprobe /run/booted-system/sw/bin/modprobe \
      --replace " grep " " ${gnugrep}/bin/grep " \
      --replace " xargs " " ${findutils}/bin/xargs "
  '';

  meta = {
    homepage = http://packages.ubuntu.com/source/saucy/kmod;
    description = "Linux kernel module blacklists from Ubuntu";
    platforms = stdenv.lib.platforms.linux;
  };
}
