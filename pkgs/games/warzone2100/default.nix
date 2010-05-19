{ stdenv, fetchurl, bison, flex, gettext, pkgconfig, SDL, libpng, libtheora
, openal, popt, physfs, mesa, quesoglc, zip, unzip, which
}:
stdenv.mkDerivation rec {
  pname = "warzone2100";
  version = "2.3.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "10iisg6lixs8bnd57qzyf3bqhispcylxvkyqwyfagg7r2qr159zj";
  };
  buildInputs = [ bison flex gettext pkgconfig SDL libpng libtheora openal
                  popt physfs mesa quesoglc zip unzip
                ];
  patchPhase = ''
    substituteInPlace lib/exceptionhandler/dumpinfo.cpp \
                      --replace "which %s" "${which}/bin/which %s"
    substituteInPlace lib/exceptionhandler/exceptionhandler.c \
                      --replace "which %s" "${which}/bin/which %s"
  '';
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
