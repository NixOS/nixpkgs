{ lib, stdenv, fetchurl, makeWrapper, pkg-config, texinfo
, cairo, gd, libcerf, pango, readline, zlib
, withTeXLive ? false, texlive
, withLua ? false, lua
, withCaca ? false, libcaca
, libX11 ? null
, libXt ? null
, libXpm ? null
, libXaw ? null
, aquaterm ? false
, withWxGTK ? false, wxGTK32, Cocoa
, fontconfig ? null
, gnused ? null
, coreutils ? null
, withQt ? false, mkDerivation, qttools, qtbase, qtsvg
}:

assert libX11 != null -> (fontconfig != null && gnused != null && coreutils != null);
let
  withX = libX11 != null && !aquaterm && !stdenv.isDarwin;
in
(if withQt then mkDerivation else stdenv.mkDerivation) rec {
  pname = "gnuplot";
  version = "5.4.8";

  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/${pname}-${version}.tar.gz";
    sha256 = "sha256-kxJ5x8qtGv99RstHZvH/QcJtm+na8Lzwx53u7j2R9c8=";
  };

  nativeBuildInputs = [ makeWrapper pkg-config texinfo ] ++ lib.optional withQt qttools;

  buildInputs =
    [ cairo gd libcerf pango readline zlib ]
    ++ lib.optional withTeXLive (texlive.combine { inherit (texlive) scheme-small; })
    ++ lib.optional withLua lua
    ++ lib.optional withCaca libcaca
    ++ lib.optionals withX [ libX11 libXpm libXt libXaw ]
    ++ lib.optionals withQt [ qtbase qtsvg ]
    ++ lib.optional withWxGTK wxGTK32
    ++ lib.optional (withWxGTK && stdenv.isDarwin) Cocoa;

  postPatch = ''
    # lrelease is in qttools, not in qtbase.
    sed -i configure -e 's|''${QT5LOC}/lrelease|lrelease|'
  '';

  configureFlags = [
    (if withX then "--with-x" else "--without-x")
    (if withQt then "--with-qt=qt5" else "--without-qt")
    (if aquaterm then "--with-aquaterm" else "--without-aquaterm")
  ] ++ lib.optional withCaca "--with-caca";

  CXXFLAGS = lib.optionalString (stdenv.isDarwin && withQt) "-std=c++11";

  # we'll wrap things ourselves
  dontWrapGApps = true;
  dontWrapQtApps = true;

  # binary wrappers don't support --run
  postInstall = lib.optionalString withX ''
    wrapProgramShell $out/bin/gnuplot \
       --prefix PATH : '${lib.makeBinPath [ gnused coreutils fontconfig.bin ]}' \
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

  meta = with lib; {
    homepage = "http://www.gnuplot.info/";
    description = "A portable command-line driven graphing utility for many platforms";
    platforms = platforms.linux ++ platforms.darwin;
    license = {
      # Essentially a BSD license with one modifaction:
      # Permission to modify the software is granted, but not the right to
      # distribute the complete modified source code.  Modifications are to
      # be distributed as patches to the released version.  Permission to
      # distribute binaries produced by compiling modified sources is granted,
      # provided you: ...
      url = "https://sourceforge.net/p/gnuplot/gnuplot-main/ci/master/tree/Copyright";
    };
    maintainers = with maintainers; [ lovek323 ];
  };
}
