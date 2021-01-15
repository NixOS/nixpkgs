{ lib, stdenv
, fetchurl
, pkgconfig
, gettext
, guile
, guile-reader
, guile-lib
, ploticus
, imagemagick
, ghostscript
, transfig
, enableEmacs ? false, emacs ? null
, enableLout ? true, lout ? null
, enableTex ? true, tex ? null
, makeWrapper
}:

let
  pname = "skribilo";
  version = "0.9.5";
  inherit (lib) optional;
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/skribilo/${pname}-${version}.tar.gz";
    sha256 = "sha256-AIJqIcRjT7C0EO6J60gGjERdgAglh0ZU49U9XKPwvwk=";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ gettext guile ploticus imagemagick ghostscript transfig ]
  ++ optional enableEmacs emacs
  ++ optional enableLout lout
  ++ optional enableTex tex;

  propagatedBuildInputs = [ guile-reader guile-lib ];

  postInstall = ''
    wrapProgram $out/bin/skribilo \
      --prefix GUILE_LOAD_PATH : "$out/share/guile/site:${guile-lib}/share/guile/site:${guile-reader}/share/guile/site" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/share/guile/site:${guile-lib}/share/guile/site:${guile-reader}/share/guile/site"
  '';

  meta = with lib;{
    description = "The Ultimate Document Programming Framework";
    longDescription = ''
      Skribilo is a free document production tool that takes a
      structured document representation as its input and renders that
      document in a variety of output formats: HTML and Info for
      on-line browsing, and Lout and LaTeX for high-quality hard
      copies.

      The input document can use Skribilo's markup language to provide
      information about the document's structure, which is similar to
      HTML or LaTeX and does not require expertise. Alternatively, it
      can use a simpler, "markup-less" format that borrows from Emacs'
      outline mode and from other conventions used in emails, Usenet
      and text.
    '';
    homepage = "https://www.nongnu.org/skribilo/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: Better Emacs and TeX integration
