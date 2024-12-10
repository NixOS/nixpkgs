{
  lib,
  stdenv,
  fetchurl,
  gettext,
  gperf,
  imagemagick,
  makeWrapper,
  pkg-config,
  SDL2,
  cairo,
  freetype,
  fribidi,
  libimagequant,
  libpaper,
  libpng,
  librsvg,
  pango,
  SDL2_gfx,
  SDL2_image,
  SDL2_mixer,
  SDL2_Pango,
  SDL2_ttf,
  netpbm,
}:

let
  stamps = fetchurl {
    url = "mirror://sourceforge/project/tuxpaint/tuxpaint-stamps/2023-07-20/tuxpaint-stamps-2023.07.20.tar.gz";
    hash = "sha256-D7QgYXRRdZpN3Ni/4lXoXCtsJORT+T2hHaLUFpgDeEI=";
  };
in
stdenv.mkDerivation rec {
  version = "0.9.31";
  pname = "tuxpaint";

  src = fetchurl {
    url = "mirror://sourceforge/tuxpaint/${version}/tuxpaint-${version}.tar.gz";
    hash = "sha256-GoXAT6XJrms//Syo+oaoTAyLRitQWfofwsRFtc+oV+4=";
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
    rm -rf $out/share/tuxpaint/stamps/military

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
  };
}
