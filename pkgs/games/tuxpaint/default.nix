{ lib, stdenv, fetchurl, SDL, SDL_gfx, SDL_image, SDL_ttf, SDL_mixer, libpng
, libimagequant, cairo, librsvg, gettext, libpaper, fribidi, pkg-config, gperf
, imagemagick
}:

stdenv.mkDerivation rec {
  version = "0.9.28";
  pname = "tuxpaint";

  src = fetchurl {
    url = "mirror://sourceforge/tuxpaint/${version}/${pname}-${version}-sdl1.tar.gz";
    sha256 = "sha256-b4Ru9GqyGf2jMmM24szGXO2vbSxCwvPmA6tgEUWhhos=";
  };

  nativeBuildInputs = [
    SDL SDL_gfx SDL_image SDL_ttf SDL_mixer libpng cairo libimagequant librsvg
    gettext libpaper fribidi pkg-config gperf imagemagick
  ];
  hardeningDisable = [ "format" ];
  makeFlags = [ "GPERF=${gperf}/bin/gperf"
                "PREFIX=$$out"
                "COMPLETIONDIR=$$out/share/bash-completion/completions"
              ];

  patches = [ ./tuxpaint-completion.diff ];
  postPatch = ''
    grep -Zlr include.*SDL . | xargs -0 sed -i -e 's,"SDL,"SDL/SDL,'
  '';

  # stamps
  stamps = fetchurl {
    url = "mirror://sourceforge/project/tuxpaint/tuxpaint-stamps/2022-06-04/tuxpaint-stamps-2022.06.04.tar.gz";
    sha256 = "sha256-hCBlV2+uVUNY4A5R1xpJJhamSQsStZIigGdHfCh6C/g=";
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
