{ stdenv, fetchurl, gnumake, file }:

stdenv.mkDerivation rec {
  name = "keyutils-1.5.8";
  
  src = fetchurl {
    url = "http://people.redhat.com/dhowells/keyutils/${name}.tar.bz2";
    sha256 = "17419fr7mph8wlhxpqb1bdrghz0db15bmjdgxg1anfgbf9ra6zbc";
  };

  buildInputs = [ file ];

  patchPhase = ''
    sed -i -e "s,/usr/bin/make,${gnumake}/bin/make," \
        -e "s, /etc, $out/etc," \
        -e "s, /bin, $out/bin," \
        -e "s, /sbin, $out/sbin," \
        -e "s, /lib, $out/lib," \
        -e "s, /lib64, $out/lib64," \
        -e "s,/usr,$out," \
        Makefile
  '';
  
  meta = {
    homepage = http://people.redhat.com/dhowells/keyutils/;
    description = "Tools used to control the Linux kernel key management system";
    license = "GPLv2+";
  };
}
