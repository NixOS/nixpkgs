{ stdenv, fetchurl, xproto, libXt, libX11, gifview ? false, static ? false }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "gifsicle-1.84";

  src = fetchurl {
    url = http://www.lcdf.org/gifsicle/gifsicle-1.84.tar.gz;
    sha256 = "1ymk7lkk50fds6090icnjg69dswzz5zyiirq2ws23aagw3l46z86";
  };

  buildInputs = optional gifview [ xproto libXt libX11 ];

  LDFLAGS = optional static "-static";

  meta = {
    description = "Command-line tool for creating, editing, and getting information about GIF images and animations";
    homepage = http://www.lcdf.org/gifsicle/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
