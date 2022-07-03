{ lib, stdenv, fetchurl, SDL, SDL_gfx, SDL_image, SDL_ttf, SDL_mixer, libpng
, libimagequant, cairo, librsvg, gettext, libpaper, fribidi, pkg-config, gperf
, imagemagick
}:

stdenv.mkDerivation rec {
  version = "0.9.27";
  pname = "tuxpaint";

  src = fetchurl {
    url = "mirror://sourceforge/tuxpaint/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-qyuA6J34gijNDsCmyQtJ1UPLFXqjj7kMvTop8AFAVXo=";
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
    url = "mirror://sourceforge/project/tuxpaint/tuxpaint-stamps/2021-11-25/tuxpaint-stamps-2021.11.25.tar.gz";
    sha256 = "sha256-y1XuIbLSW0QO4has+rC7jZBq8cma28d+jbEe7DBYnVI=";
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
