{stdenv, fetchsvn, libpcap, openssl, zlib, wirelesstools}:

let
  rev = "2178";
in
stdenv.mkDerivation rec {
  name = "aircrack-ng-1.1-${rev}";

  src = fetchsvn {
    url = "http://trac.aircrack-ng.org/svn/trunk";
    inherit rev;
    sha256 = "0rwj2nk4nyy0l9dg6rpg2h5gpvcygs5irj4i6fdcsr8xf0blq7yw";
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
