{ stdenv, fetchurl, SDL, libxml2, SDL_image, libjpeg, libpng, mesa, zlib }:

let
  versionMajor = "0.2.8";
  versionMinor = "3.4";
  version = "${versionMajor}.${versionMinor}";
in

stdenv.mkDerivation {
  name = "armagetron-${version}";
  src = fetchurl {
    url = "https://launchpad.net/armagetronad/${versionMajor}/${versionMajor}.${versionMinor}/+download/armagetronad-${version}.src.tar.bz2";
    sha256 = "157pp84wf0q3bdb72rnbm3ck0czwx2ply6lyhj8z7kfdc7csdbr3";
  };

  NIX_LDFLAGS = [ "-lSDL_image" ];

  configureFlags = [ "--disable-etc" ];
  buildInputs = [ SDL SDL_image libxml2 libjpeg libpng mesa zlib ];

  meta = with stdenv.lib; {
    homepage = http://armagetronad.org;
    description = "An multiplayer networked arcade racing game in 3D similar to Tron";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
