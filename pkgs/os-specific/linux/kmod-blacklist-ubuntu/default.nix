{ stdenv, fetchurl, gnugrep, findutils }:

let
  version = "22-1.1ubuntu1"; # Zesty

in stdenv.mkDerivation {
  name = "kmod-blacklist-${version}";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/kmod_${version}.debian.tar.xz";
    sha256 = "1k749g707ccb82l4xmrkp53khl71f57cpj9fzd1qyzrz147fjyhi";
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

  meta = with stdenv.lib; {
    homepage = http://packages.ubuntu.com/source/zesty/kmod;
    description = "Linux kernel module blacklists from Ubuntu";
    platforms = platforms.linux;
  };
}
