{stdenv, fetchsvn, libpcap, openssl, zlib, wirelesstools}:

let
  rev = "2178";
in
stdenv.mkDerivation rec {
  name = "aircrack-ng-1.1-${rev}";

  src = fetchsvn {
    url = "http://trac.aircrack-ng.org/svn/trunk";
    inherit rev;
    sha256 = "d16fd3a4e918fd6a855c0d0ae0c863247a45189e6ec35c0c7082d3d07b6438db";
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
