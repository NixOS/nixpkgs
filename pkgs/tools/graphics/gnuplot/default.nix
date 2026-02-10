{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  pkg-config,
  texinfo,
  cairo,
  gd,
  libcerf,
  pango,
  readline,
  zlib,
  withTeXLive ? false,
  texliveSmall,
  withLua ? false,
  lua,
  withCaca ? false,
  libcaca,
  libx11,
  libxt,
  libxpm,
  libxaw,
  aquaterm ? false,
  withWxGTK ? false,
  wxGTK32,
  fontconfig,
  gnused,
  coreutils,
  withQt ? false,
  qttools,
  wrapQtAppsHook,
  qtbase,
  qtsvg,
}:

let
  withX = !aquaterm && !stdenv.hostPlatform.isDarwin;
in
stdenv.mkDerivation rec {
  pname = "gnuplot";
  version = "6.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/gnuplot-${version}.tar.gz";
    sha256 = "sha256-RY2UdpYl5z1fYjJQD0nLrcsrGDOA1D0iZqD5cBrrnFs=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    texinfo
  ]
  ++ lib.optionals withQt [
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    cairo
    gd
    libcerf
    pango
    readline
    zlib
  ]
  ++ lib.optional withTeXLive texliveSmall
  ++ lib.optional withLua lua
  ++ lib.optional withCaca libcaca
  ++ lib.optionals withX [
    libx11
    libxpm
    libxt
    libxaw
  ]
  ++ lib.optionals withQt [
    qtbase
    qtsvg
  ]
  ++ lib.optional withWxGTK wxGTK32;

  postPatch = ''
    # lrelease is in qttools, not in qtbase.
    sed -i configure -e 's|''${QT5LOC}/lrelease|lrelease|'
  '';

  configureFlags = [
    (if withX then "--with-x" else "--without-x")
    (if withQt then "--with-qt=qt5" else "--without-qt")
    (if aquaterm then "--with-aquaterm" else "--without-aquaterm")
  ]
  ++ lib.optional withCaca "--with-caca"
  ++ lib.optional withTeXLive "--with-texdir=${placeholder "out"}/share/texmf/tex/latex/gnuplot";

  CXXFLAGS = lib.optionalString (stdenv.hostPlatform.isDarwin && withQt) "-std=c++11";

  # we'll wrap things ourselves
  dontWrapGApps = true;
  dontWrapQtApps = true;

  # binary wrappers don't support --run
  postInstall = lib.optionalString withX ''
    wrapProgramShell $out/bin/gnuplot \
       --prefix PATH : '${
         lib.makeBinPath [
           gnused
           coreutils
           fontconfig.bin
         ]
       }' \
       "''${gappsWrapperArgs[@]}" \
       "''${qtWrapperArgs[@]}" \
       --run '. ${./set-gdfontpath-from-fontconfig.sh}'
  '';

  # When cross-compiling, don't build docs and demos.
  # Inspiration taken from https://sourceforge.net/p/gnuplot/gnuplot-main/merge-requests/10/
  makeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-C src"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.gnuplot.info/";
    description = "Portable command-line driven graphing utility for many platforms";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gnuplot;
    maintainers = with lib.maintainers; [ lovek323 ];
    mainProgram = "gnuplot";
  };
}
