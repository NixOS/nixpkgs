{ stdenv, fetchurl, xproto, libXt, libX11 }:

stdenv.mkDerivation {
  name = "gifsicle-1.52";

  src = fetchurl {
    url = http://www.lcdf.org/gifsicle/gifsicle-1.52.tar.gz;
    sha256 = "1fp47grvk46bkj22zixrhgpgs3qbkmijicf3wkjk4y8fsx0idbgk";
  };

  buildInputs = [ xproto libXt libX11 ];

  meta = { 
    description = "Command-line tool for creating, editing, and getting information about GIF images and animations";
    homepage = http://www.lcdf.org/gifsicle/;
    license = "GPL2";
  };
}
