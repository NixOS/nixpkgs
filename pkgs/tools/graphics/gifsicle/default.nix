{ stdenv, fetchurl, xproto, libXt, libX11, gifview ? false, static ? false }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "gifsicle-1.87";

  src = fetchurl {
    url = http://www.lcdf.org/gifsicle/gifsicle-1.87.tar.gz;
    sha256 = "078rih7gq86ixjqbnn5z1jsh11qlfisw6k8dxaccsh5amhybw2j7";
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
