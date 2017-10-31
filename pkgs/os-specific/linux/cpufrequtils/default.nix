{ stdenv, fetchurl, libtool, gettext }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "cpufrequtils-008";

  src = fetchurl {
    url = "http://ftp.be.debian.org/pub/linux/utils/kernel/cpufreq/${name}.tar.gz";
    sha256 = "127i38d4w1hv2dzdy756gmbhq25q3k34nqb2s0xlhsfhhdqs0lq0";
  };

  patches = [
    # I am not 100% sure that this is ok, but it breaks repeatable builds.
    ./remove-pot-creation-date.patch
  ];

  patchPhase = ''
    sed -e "s@= /usr/bin/@= @g" \
      -e "s@/usr/@$out/@" \
      -i Makefile
  '';

  buildInputs = [ stdenv.cc.libc.linuxHeaders libtool gettext ];

  meta = {
    description = "Tools to display or change the CPU governor settings";
    platforms = stdenv.lib.platforms.linux;
  };
}
