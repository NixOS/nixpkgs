{ lib, stdenv, fetchurl, zlib, gd, texinfo4, makeWrapper, readline
, withTeXLive ? false, texLive
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
, withQt ? false, qt4 }:

assert libX11 != null -> (fontconfig != null && gnused != null && coreutils != null);
let
  withX = libX11 != null && !aquaterm && !stdenv.isDarwin;
in
stdenv.mkDerivation rec {
  name = "gnuplot-4.6.5";

  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/${name}.tar.gz";
    sha256 = "0bcsa5b33msddjs6mj0rhi81cs19h9p3ykixkkl70ifhqwqg0l75";
  };

  buildInputs =
    [ zlib gd texinfo4 readline pango cairo pkgconfig makeWrapper ]
    ++ lib.optional withTeXLive texLive
    ++ lib.optional withLua lua
    ++ lib.optionals withX [ libX11 libXpm libXt libXaw ]
    ++ lib.optional withQt [ qt4 ]
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
       --prefix PATH : '${fontconfig}/bin' \
       --run '. ${./set-gdfontpath-from-fontconfig.sh}'
  '';

  meta = with lib; {
    homepage = http://www.gnuplot.info/;
    description = "A portable command-line driven graphing utility for many platforms";
    hydraPlatforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ lovek323 ];
  };
}
