{ stdenv, fetchurl, SDL, libxml2, SDL_image, libjpeg, libpng, mesa, zlib }:

let
  versionMajor = "0.2.8";
  versionMinor = "3.3";
  version = "${versionMajor}.${versionMinor}";
in

stdenv.mkDerivation {
  name = "armagetron-${version}";
  src = fetchurl {
    url = "https://launchpad.net/armagetronad/${versionMajor}/0.2.8.3.x/+download/armagetronad-${version}.src.tar.bz2";
    sha256 = "1s55irhg60fpmhy8wwxpdq7c45r1mqch6zpicyb2wf9ln60xgwnx";
  };

  NIX_LDFLAGS = [ "-lSDL_image" ];

  configureFlags = [ "--disable-etc" ];
  buildInputs = [ SDL SDL_image libxml2 libjpeg libpng mesa zlib ];

  meta = with stdenv.lib; {
    homepage = "http://armagetronad.org";
    description = "An multiplayer networked arcade racing game in 3D similar to Tron";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
