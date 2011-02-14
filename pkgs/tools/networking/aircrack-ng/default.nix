{stdenv, fetchsvn, libpcap, openssl, zlib, wirelesstools}:

let
  rev = "1859";
in
stdenv.mkDerivation rec {
  name = "aircrack-ng-1.1-${rev}";

  src = fetchsvn {
    url = "http://trac.aircrack-ng.org/svn/trunk";
    inherit rev;
    sha256 = "6ca98321ef3f14af9c78b2fe25091c4e79e3c28679f240b80f8aeda71b84ab4a";
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
