{ fetchurl, lib, stdenv, cmake, xlibsWrapper, libGLU, libGL, SDL, openal, freealut, libogg, libvorbis, runtimeShell }:

stdenv.mkDerivation rec {
  version = "1.3.2";
  pname = "astromenace";

  src = fetchurl {
    url = "mirror://sourceforge/openastromenace/astromenace-src-${version}.tar.bz2";
    sha256 = "1rkz6lwjcd5mwv72kf07ghvx6z46kf3xs250mjbmnmjpn7r5sxwv";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ xlibsWrapper libGLU libGL SDL openal freealut libogg libvorbis ];

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
    #!${runtimeShell}
    $out/AstroMenace --dir=$out
    EOF
    chmod 755 $out/bin/AstroMenace
  '';

  meta = {
    description = "Hardcore 3D space shooter with spaceship upgrade possibilities";
    homepage = "https://www.viewizard.com/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "AstroMenace";
  };
}
