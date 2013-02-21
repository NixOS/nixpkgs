{stdenv, fetchsvn, libpcap, openssl, zlib, wirelesstools}:

let
  rev = "2212";
in
stdenv.mkDerivation rec {
  name = "aircrack-ng-1.1-${rev}";

  src = fetchsvn {
    url = "http://trac.aircrack-ng.org/svn/trunk";
    inherit rev;
    sha256 = "80e567b4e4bc501721cd58f7efadcd13fc3b235a41486174826694a6e701ce09";
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
