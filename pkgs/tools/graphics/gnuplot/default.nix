{ lib, stdenv, fetchurl, zlib, gd, texinfo4, makeWrapper, readline
, withTeXLive ? false, texlive
, withLua ? false, lua
, emacs ? null
, libX11 ? null
, libXt ? null
, libXpm ? null
, libXaw ? null
, aquaterm ? false
, withWxGTK ? false, wxGTK ? null
, pango ? null
, cairo ? null
, pkgconfig ? null
, fontconfig ? null
, gnused ? null
, coreutils ? null
, withQt ? false, qt }:

assert libX11 != null -> (fontconfig != null && gnused != null && coreutils != null);
let
  withX = libX11 != null && !aquaterm && !stdenv.isDarwin;
in
stdenv.mkDerivation rec {
  name = "gnuplot-5.0.6";

  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/${name}.tar.gz";
    sha256 = "0q5lr6nala3ln6f3yp6g17ziymb9r9gx9zylnw1y3hjmwl9lggjv";
  };

  buildInputs =
    [ zlib gd texinfo4 readline pango cairo pkgconfig makeWrapper ]
    ++ lib.optional withTeXLive (texlive.combine { inherit (texlive) scheme-small; })
    ++ lib.optional withLua lua
    ++ lib.optionals withX [ libX11 libXpm libXt libXaw ]
    ++ lib.optional withQt qt
    # compiling with wxGTK causes a malloc (double free) error on darwin
    ++ lib.optional (withWxGTK && !stdenv.isDarwin) wxGTK;

  configureFlags =
    (if withX then ["--with-x"] else ["--without-x"])
    ++ (if withQt then ["--enable-qt"] else ["--disable-qt"])
    ++ (if aquaterm then ["--with-aquaterm"] else ["--without-aquaterm"]);

  postInstall = lib.optionalString withX ''
    wrapProgram $out/bin/gnuplot \
       --prefix PATH : '${gnused}/bin' \
       --prefix PATH : '${coreutils}/bin' \
       --prefix PATH : '${fontconfig.bin}/bin' \
       --run '. ${./set-gdfontpath-from-fontconfig.sh}'
  '';

  meta = with lib; {
    homepage = http://www.gnuplot.info/;
    description = "A portable command-line driven graphing utility for many platforms";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ lovek323 ];
  };
}
