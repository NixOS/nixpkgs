{ fetchurl, stdenv, SDL, openal, SDL_mixer, libxml2, pkgconfig, libvorbis
, libpng, mesa, makeWrapper, zlib }:

let
  pname = "naev";
  version = "0.5.0";
  name = "${pname}-${version}";
in
stdenv.mkDerivation {
  inherit name;

  srcData = fetchurl {
    url = "mirror://sourceforge/naev/ndata-${version}";
    sha256 = "0l05xxbbys3j5h6anvann2vylhp6hnxnzwpcaydaff8fpbbyi6r6";
  };

  src = fetchurl {
    url = "mirror://sourceforge/naev/${name}.tar.bz2";
    sha256 = "0gahi91lmpra0wvxsz49zwwb28q9w2v1s3y7r70252hq6v80kanb";
  };

  buildInputs = [ SDL SDL_mixer openal libxml2 libvorbis libpng mesa zlib ];

  buildNativeInputs = [ pkgconfig makeWrapper ];

  NIX_CFLAGS_COMPILE="-include ${zlib}/include/zlib.h";

  postInstall = ''
    mkdir -p $out/share/naev
    cp -v $srcData $out/share/naev/ndata
    wrapProgram $out/bin/naev --add-flags $out/share/naev/ndata
  '';

  meta = {
    description = "2D action/rpg space game";
    homepage = http://www.naev.org;
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
