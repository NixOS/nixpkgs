{ lib, stdenv, fetchurl, SDL2, SDL2_gfx, SDL2_image, SDL2_ttf, SDL2_mixer
, SDL2_Pango, libpng, freetype, pango, libimagequant, cairo, librsvg, gettext
, libpaper, fribidi, pkg-config, gperf, imagemagick
}:

stdenv.mkDerivation rec {
  version = "0.9.31";
  pname = "tuxpaint";

  src = fetchurl {
    url = "mirror://sourceforge/tuxpaint/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-GoXAT6XJrms//Syo+oaoTAyLRitQWfofwsRFtc+oV+4=";
  };

  nativeBuildInputs = [
    SDL2 SDL2_gfx SDL2_image SDL2_ttf SDL2_mixer SDL2_Pango libpng cairo
    libimagequant librsvg gettext libpaper fribidi pkg-config gperf
    imagemagick pango freetype
  ];
  hardeningDisable = [ "format" ];
  makeFlags = [ "GPERF=${gperf}/bin/gperf"
                "PREFIX=$$out"
                "COMPLETIONDIR=$$out/share/bash-completion/completions"
              ];

  patches = [ ./tuxpaint-completion.diff ];
  postPatch = ''
    grep -Zlr include.*SDL . | xargs -0 sed -i -E -e 's,"(SDL2?_?[a-zA-Z]*.h),"SDL2/\1,' -e 's,SDL2/SDL2_Pango.h,SDL2_Pango.h,'
  '';

  # stamps
  stamps = fetchurl {
    url = "mirror://sourceforge/project/tuxpaint/tuxpaint-stamps/2023-07-20/tuxpaint-stamps-2023.07.20.tar.gz";
    sha256 = "sha256-D7QgYXRRdZpN3Ni/4lXoXCtsJORT+T2hHaLUFpgDeEI=";
  };

  postInstall = ''
    # Install desktop file
    mkdir -p $out/share/applications
    cp hildon/tuxpaint.xpm $out/share/pixmaps
    sed -e "s+Exec=tuxpaint+Exec=$out/bin/tuxpaint+" < src/tuxpaint.desktop > $out/share/applications/tuxpaint.desktop

    # Install stamps
    tar xzf $stamps
    cd tuxpaint-stamps-*
    make install-all PREFIX=$out
    rm -rf $out/share/tuxpaint/stamps/military
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open Source Drawing Software for Children";
    homepage = "http://www.tuxpaint.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
}
