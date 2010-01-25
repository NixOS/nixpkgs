{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "keyutils-1.2";
  
  src = fetchurl {
    url = http://people.redhat.com/dhowells/keyutils/keyutils-1.2.tar.bz2;
    sha256 = "0gcv47crbaw6crgn02j1w75mknhnwgkhmfcmwq2qi9iwiwprnv9h";
  };

  patchPhase = ''
    sed -i -e "s, /etc, $out/etc," \
        -e "s, /bin, $out/bin," \
        -e "s, /sbin, $out/sbin," \
        -e "s, /lib, $out/lib," \
        -e "s,/usr,$out," \
        Makefile
  '';
  
  meta = {
    homepage = http://people.redhat.com/dhowells/keyutils/;
    description = "Tools used to control the Linux kernel key management system";
    license = "GPLv2+";
  };
}
