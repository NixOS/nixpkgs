{ stdenv, fetchurl, xorgproto, libXt, libX11, gifview ? false, static ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gifsicle-${version}";
  version = "1.91";

  src = fetchurl {
    url = "https://www.lcdf.org/gifsicle/${name}.tar.gz";
    sha256 = "00586z1yz86qcblgmf16yly39n4lkjrscl52hvfxqk14m81fckha";
  };

  buildInputs = optional gifview [ xorgproto libXt libX11 ];

  configureFlags = []
    ++ optional (!gifview) [ "--disable-gifview" ];

  LDFLAGS = optional static "-static";

  doCheck = true;
  checkPhase = ''
    ./src/gifsicle --info logo.gif
  '';

  meta = {
    description = "Command-line tool for creating, editing, and getting information about GIF images and animations";
    homepage = https://www.lcdf.org/gifsicle/;
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.all;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu zimbatm ];
  };
}
