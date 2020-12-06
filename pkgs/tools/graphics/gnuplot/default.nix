{ lib, stdenv, fetchurl, makeWrapper, pkgconfig, texinfo
, cairo, gd, libcerf, pango, readline, zlib
, withTeXLive ? false, texlive
, withLua ? false, lua
, libX11 ? null
, libXt ? null
, libXpm ? null
, libXaw ? null
, aquaterm ? false
, withWxGTK ? false, wxGTK ? null
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
  version = "5.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/${pname}-${version}.tar.gz";
    sha256 = "0iwwliq5a6qcawbpxk4d7l17fpkq9xxcz05kwblx37rr7bq84h7b";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig texinfo ] ++ lib.optional withQt qttools;

  buildInputs =
    [ cairo gd libcerf pango readline zlib ]
    ++ lib.optional withTeXLive (texlive.combine { inherit (texlive) scheme-small; })
    ++ lib.optional withLua lua
    ++ lib.optionals withX [ libX11 libXpm libXt libXaw ]
    ++ lib.optionals withQt [ qtbase qtsvg ]
    ++ lib.optional withWxGTK wxGTK;

  postPatch = ''
    # lrelease is in qttools, not in qtbase.
    sed -i configure -e 's|''${QT5LOC}/lrelease|lrelease|'
  '';

  configureFlags = [
    (if withX then "--with-x" else "--without-x")
    (if withQt then "--with-qt=qt5" else "--without-qt")
    (if aquaterm then "--with-aquaterm" else "--without-aquaterm")
  ];

  CXXFLAGS = lib.optionalString (stdenv.isDarwin && withQt) "-std=c++11";

  postInstall = lib.optionalString withX ''
    wrapProgram $out/bin/gnuplot \
       --prefix PATH : '${gnused}/bin' \
       --prefix PATH : '${coreutils}/bin' \
       --prefix PATH : '${fontconfig.bin}/bin' \
       --run '. ${./set-gdfontpath-from-fontconfig.sh}'
  '' + lib.optionalString (stdenv.isDarwin && withQt) ''
     wrapQtApp $out/bin/gnuplot
  '';

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
