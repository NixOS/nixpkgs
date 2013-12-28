{ stdenv, fetchurl, xproto, libXt, libX11 }:

stdenv.mkDerivation {
  name = "gifsicle-1.78";

  src = fetchurl {
    url = http://www.lcdf.org/gifsicle/gifsicle-1.78.tar.gz;
    sha256 = "0dzp5sg82klji4lbj1m4cyg9fb3l837gkipdx657clib97klyv53";
  };

  buildInputs = [ xproto libXt libX11 ];

  meta = { 
    description = "Command-line tool for creating, editing, and getting information about GIF images and animations";
    homepage = http://www.lcdf.org/gifsicle/;
    license = "GPL2";
  };
}
