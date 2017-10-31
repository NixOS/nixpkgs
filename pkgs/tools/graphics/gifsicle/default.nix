{ stdenv, fetchurl, xproto, libXt, libX11, gifview ? false, static ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gifsicle-${version}";
  version = "1.88";

  src = fetchurl {
    url = "http://www.lcdf.org/gifsicle/${name}.tar.gz";
    sha256 = "4585d2e683d7f68eb8fcb15504732d71d7ede48ab5963e61915201f9e68305be";
  };

  buildInputs = optional gifview [ xproto libXt libX11 ];

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
