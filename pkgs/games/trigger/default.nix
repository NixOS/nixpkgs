{ fetchurl, stdenv, SDL, freealut, SDL_image, openal, physfs, zlib, mesa, jam }:

stdenv.mkDerivation rec {
  name = "trigger-rally-0.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/trigger-rally/${name}-src.tar.bz2";
    sha256 = "0qm6anlcqx19iaiz0zh0bf74g9nc6gr8cy0lbsxahwgzkwsqz0fw";
  };

  srcData = fetchurl {
    url = "mirror://sourceforge/trigger-rally/trigger-rally-0.6.0-data.tar.bz2";
    sha256 = "161mfgv68my2231d8ps4zs1axisrj0lkcc4yqsr0x28w0mr19j4y";
  };

  buildInputs = [ SDL freealut SDL_image openal physfs zlib mesa jam ];

  preConfigure = ''
    configureFlags="$configureFlags --datadir=$out/share/trigger-rally-0.6.0-data"
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
