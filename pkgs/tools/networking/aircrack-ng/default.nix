{stdenv, fetchurl, libpcap, openssl, zlib, wirelesstools}:

stdenv.mkDerivation rec {
  name = "aircrack-ng-1.2-beta1";

  src = fetchurl {
    url = "http://download.aircrack-ng.org/${name}.tar.gz";
    sha256 = "19cfib7sqp2rdm3lc84jrzsa6r8443gkm1ifbmhygsqn6fnkj8zi";
  };

  buildInputs = [libpcap openssl zlib];

  patchPhase = ''
    sed -e 's@^prefix.*@prefix = '$out@ -i common.mak
    sed -e 's@/usr/local/bin@'${wirelesstools}@ -i src/osdep/linux.c
    '';

  meta = {
    description = "Wireless encryption crackign tools";
    homepage = http://www.aircrack-ng.org/;
    license = "GPL2+";
  };
}
