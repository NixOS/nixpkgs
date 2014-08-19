{ stdenv, fetchurl, xproto, libXt, libX11, gifview ? false, static ? false }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "gifsicle-1.78";

  src = fetchurl {
    url = http://www.lcdf.org/gifsicle/gifsicle-1.78.tar.gz;
    sha256 = "0dzp5sg82klji4lbj1m4cyg9fb3l837gkipdx657clib97klyv53";
  };

  buildInputs = optional gifview [ xproto libXt libX11 ];

  LDFLAGS = optional static "-static";

  meta = { 
    description = "Command-line tool for creating, editing, and getting information about GIF images and animations";
    homepage = http://www.lcdf.org/gifsicle/;
    license = stdenv.lib.licenses.gpl2;
  };
}
