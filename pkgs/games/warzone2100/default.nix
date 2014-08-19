{ stdenv, fetchurl, bison, flex, gettext, pkgconfig, libpng
, libtheora, openalSoft, physfs, mesa, fribidi, fontconfig
, freetype, qt4, glew, libogg, libvorbis, zlib, libX11
, libXrandr, zip, unzip, which
, withVideos ? false
}:
stdenv.mkDerivation rec {
  pname = "warzone2100";
  version = "3.1.1";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/releases/${version}/${name}.tar.xz";
    sha256 = "c937a2e2c7afdad00b00767636234bbec4d8b18efb008073445439d32edb76cf";
  };
  sequences_src = fetchurl {
    url = "mirror://sourceforge/${pname}/warzone2100/Videos/high-quality-en/sequences.wz";
    sha256 = "90ff552ca4a70e2537e027e22c5098ea4ed1bc11bb7fc94138c6c941a73d29fa";
  };
  buildInputs = [ bison flex gettext pkgconfig libpng libtheora openalSoft
                  physfs mesa fribidi fontconfig freetype qt4
                  glew libogg libvorbis zlib libX11 libXrandr zip
                  unzip
                ];
  patchPhase = ''
    substituteInPlace lib/exceptionhandler/dumpinfo.cpp \
                      --replace "which %s" "${which}/bin/which %s"
    substituteInPlace lib/exceptionhandler/exceptionhandler.cpp \
                      --replace "which %s" "${which}/bin/which %s"
  '';
  configureFlags = "--with-backend=qt --with-distributor=NixOS";
  postInstall = []
    ++ stdenv.lib.optional withVideos "cp ${sequences_src} $out/share/warzone2100/sequences.wz";
  meta = {
    description = "A free RTS game, originally developed by Pumpkin Studios";
    longDescription = ''
        Warzone 2100 is an open source real-time strategy and real-time tactics
      hybrid computer game, originally developed by Pumpkin Studios and
      published by Eidos Interactive.
        In Warzone 2100, you command the forces of The Project in a battle to
      rebuild the world after mankind has almost been destroyed by nuclear
      missiles. The game offers campaign, multi-player, and single-player
      skirmish modes. An extensive tech tree with over 400 different
      technologies, combined with the unit design system, allows for a wide
      variety of possible units and tactics. 
    '';
    homepage = http://wz2100.net;
    license = [ "GPLv2+" ];
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
