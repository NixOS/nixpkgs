{ stdenv, fetchurl, gnugrep, findutils }:
let
  version = "18-3ubuntu1"; # Vivid
in
stdenv.mkDerivation {
  name = "kmod-blacklist-${version}";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/kmod_${version}.debian.tar.xz";
    sha256 = "14ypc1ij9rjnkz4zklbxpgf0ac1bnqlx0mjv0pjjvrrf857fiq94";
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
  };
}
