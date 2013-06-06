{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "txt2man-1.5.6";

  src = fetchurl {
    url = "http://mvertes.free.fr/download/${name}.tar.gz";
    sha256 = "0ammlb4pwc4ya1kc9791vjl830074zrpfcmzc18lkcqczp2jaj4q";
  };

  preConfigure = ''
    makeFlags=prefix="$out"
  '';

  meta = { 
    description = "Convert flat ASCII text to man page format";
    homepage = http://mvertes.free.fr/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bjornfor ];
  };
}
