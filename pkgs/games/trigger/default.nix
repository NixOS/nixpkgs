{ fetchurl, stdenv, SDL, freealut, SDL_image, openal, physfs, zlib, mesa, jam }:

stdenv.mkDerivation rec {
  name = "trigger-0.5.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/trigger-rally/${name}-src.tar.bz2";
    sha256 = "17sbw6j2z62w047fb8vlkabhq7s512r3a4pjd6402lpq09mpywhg";
  };

  srcData = fetchurl {
    url = "mirror://sourceforge/trigger-rally/trigger-0.5.2-data.tar.bz2";
    sha256 = "0sxfpn2vqzgv1dm66j75bmfc1kmnwrv1bb1yazmm803nnngk6zy9";
  };

  buildInputs = [ SDL freealut SDL_image openal physfs zlib mesa jam ];

  preConfigure = ''
    configureFlags="$configureFlags --datadir=$out/share/trigger-0.5.2-data"
  '';

  # It has some problems installing the README file, so... out.
  patchPhase = ''
    sed -i /README/d Jamfile
  '';

  buildPhase = "jam";

  installPhase = ''
    jam install
    ensureDir $out/share
    pushd $out/share
    tar xf $srcData
  '';

  meta = {
    description = "Rally";
    homepage = http://trigger-rally.sourceforge.net/;
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
