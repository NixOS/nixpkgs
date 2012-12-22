{stdenv, fetchurl, scons, SDL, SDL_image, boost, libpng, SDL_mixer, pkgconfig
, mesa}:
let
  buildInputs = [scons SDL SDL_image boost libpng SDL_mixer pkgconfig mesa];
  s = # Generated upstream information
  rec {
    baseName="pingus";
    version="0.7.6";
    name="pingus-0.7.6";
    hash="0q34d2k6anzqvb0mf67x85q92lfx9jr71ry13dlp47jx0x9i573m";
    url="http://pingus.googlecode.com/files/pingus-0.7.6.tar.bz2";
    sha256="0q34d2k6anzqvb0mf67x85q92lfx9jr71ry13dlp47jx0x9i573m";
  };
in
stdenv.mkDerivation rec {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  makeFlags = '' PREFIX="$(out)" '';
  meta = {
    inherit (s) version;
    description = ''A puzzle game with mechanics similar to Lemmings'';
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.raskin];
    license = stdenv.lib.licenses.gpl3;
  };
}
