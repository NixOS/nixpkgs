{stdenv, fetchurl, libpcap, openssl, zlib, wirelesstools}:

stdenv.mkDerivation {
  name = "aircrack-ng-1.0-rc2";

  src = fetchurl {
    url = http://download.aircrack-ng.org/aircrack-ng-1.0-rc2.tar.gz;
    sha256 = "9d52f15f3fca52775ecb9cfc1f0aeb04c3c3bd3101665d5760d395f7d2a87d8b";
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
