{ lib
, stdenv
, fetchurl
, gettext
, gperf
, imagemagick
, makeWrapper
, pkg-config
, SDL2
, cairo
, freetype
, fribidi
, libimagequant
, libpaper
, libpng
, librsvg
, pango
, SDL2_gfx
, SDL2_image
, SDL2_mixer
, SDL2_Pango
, SDL2_ttf
, netpbm
}:

let
  stamps = fetchurl {
    url = "mirror://sourceforge/project/tuxpaint/tuxpaint-stamps/2024-01-29/tuxpaint-stamps-2024.01.29.tar.gz";
    hash = "sha256-GwJx9tqaX7I623tJQYO53iiaApZtYsTLQw2ptBIFlKk=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  version = "0.9.32";
  pname = "tuxpaint";

  src = fetchurl {
    url = "mirror://sourceforge/tuxpaint/${finalAttrs.version}/tuxpaint-${finalAttrs.version}.tar.gz";
    hash = "sha256-CcziIkFIHcE2D8S8XU2h0xgV16JWO56fohemcrqXS/I=";
  };

  patches = [
    ./tuxpaint-completion.diff
  ];

  postPatch = ''
    grep -Zlr include.*SDL . | xargs -0 \
      sed -i -E \
        -e 's,"(SDL2?_?[a-zA-Z]*.h),"SDL2/\1,' \
        -e 's,SDL2/SDL2_Pango.h,SDL2_Pango.h,'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    gperf
    imagemagick
    makeWrapper
    pkg-config
    SDL2
  ];

  buildInputs = [
    cairo
    freetype
    fribidi
    libimagequant
    libpaper
    libpng
    librsvg
    pango
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_Pango
    SDL2_ttf
  ];

  hardeningDisable = [ "format" ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "COMPLETIONDIR=$(out)/share/bash-completion/completions"
    "GPERF=${lib.getExe gperf}"
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    # Install desktop file
    mkdir -p $out/share/applications
    cp hildon/tuxpaint.xpm $out/share/pixmaps
    sed -e "s+Exec=tuxpaint+Exec=$out/bin/tuxpaint+" < src/tuxpaint.desktop > $out/share/applications/tuxpaint.desktop

    # Install stamps
    tar xzf ${stamps}
    cd tuxpaint-stamps-*
    make install-all PREFIX=$out

    # Requirements for tuxpaint-import
    wrapProgram $out/bin/tuxpaint-import \
      --prefix PATH : ${lib.makeBinPath [ netpbm ]}
  '';

  meta = {
    description = "Open Source Drawing Software for Children";
    homepage = "http://www.tuxpaint.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
    mainProgram = "tuxpaint";
  };
})
