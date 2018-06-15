{ fetchurl, stdenv, cmake, xlibsWrapper, libGLU_combined, SDL, openal, freealut, libogg, libvorbis }:

stdenv.mkDerivation rec {
  version = "1.3.2";
  name = "astromenace-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/openastromenace/astromenace-src-${version}.tar.bz2";
    sha256 = "1rkz6lwjcd5mwv72kf07ghvx6z46kf3xs250mjbmnmjpn7r5sxwv";
  };

  buildInputs = [ cmake xlibsWrapper libGLU_combined SDL openal freealut libogg libvorbis ];

  buildPhase = ''
    cmake ./
    make
    ./AstroMenace --pack --rawdata=../RAW_VFS_DATA
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp AstroMenace $out
    cp gamedata.vfs $out
    cat > $out/bin/AstroMenace << EOF
    #!${stdenv.shell}
    $out/AstroMenace --dir=$out
    EOF
    chmod 755 $out/bin/AstroMenace
  '';

  meta = {
    description = "Hardcore 3D space shooter with spaceship upgrade possibilities";
    homepage = http://www.viewizard.com/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
