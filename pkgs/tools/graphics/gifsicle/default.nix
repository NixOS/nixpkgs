{ stdenv, fetchurl, xproto, libXt, libX11, gifview ? false, static ? false }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "gifsicle-1.86";

  src = fetchurl {
    url = http://www.lcdf.org/gifsicle/gifsicle-1.86.tar.gz;
    sha256 = "153knkff04wh1szbmqklyq371m9whib007j0lq0dwh4jc5g6s15h";
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
