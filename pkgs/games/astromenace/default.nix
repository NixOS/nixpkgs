{ fetchurl, lib, stdenv, cmake, xorg, libGLU, libGL, SDL, openal, fontconfig, freealut, freetype, libogg, libvorbis, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "astromenace";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/openastromenace/astromenace-src-${version}.tar.bz2";
    sha256 = "1rkz6lwjcd5mwv72kf07ghvx6z46kf3xs250mjbmnmjpn7r5sxwv";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ xorg.libICE xorg.libX11 xorg.libXinerama libGLU libGL SDL openal fontconfig freealut freetype libogg libvorbis ];

  postBuild = ''
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

  meta = with lib; {
    description = "Hardcore 3D space shooter with spaceship upgrade possibilities";
    homepage = "https://www.viewizard.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "AstroMenace";
  };
}
