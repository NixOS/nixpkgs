{ lib
, stdenv
, fetchurl
, gettext
, ghostscript
, guile
, guile-lib
, guile-reader
, imagemagick
, makeWrapper
, pkg-config
, ploticus
, fig2dev
, enableEmacs ? false, emacs
, enableLout ? true, lout
, enableTex ? true, tex
}:

let
  inherit (lib) optional;
in stdenv.mkDerivation rec{
  pname = "skribilo";
  version = "0.9.5";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/skribilo/${pname}-${version}.tar.gz";
    sha256 = "sha256-AIJqIcRjT7C0EO6J60gGjERdgAglh0ZU49U9XKPwvwk=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    gettext
    ghostscript
    guile
    guile-lib
    guile-reader
    imagemagick
    ploticus
    fig2dev
  ]
  ++ optional enableEmacs emacs
  ++ optional enableLout lout
  ++ optional enableTex tex;

  postInstall =
    let
      guileVersion = lib.versions.majorMinor guile.version;
    in
    ''
      wrapProgram $out/bin/skribilo \
        --prefix GUILE_LOAD_PATH : "$out/share/guile/site/${guileVersion}:$GUILE_LOAD_PATH" \
        --prefix GUILE_LOAD_COMPILED_PATH : "$out/lib/guile/${guileVersion}/site-ccache:$GUILE_LOAD_COMPILED_PATH"
    '';

  meta = with lib; {
    homepage = "https://www.nongnu.org/skribilo/";
    description = "The Ultimate Document Programming Framework";
    longDescription = ''
      Skribilo is a free document production tool that takes a structured
      document representation as its input and renders that document in a
      variety of output formats: HTML and Info for on-line browsing, and Lout
      and LaTeX for high-quality hard copies.

      The input document can use Skribilo's markup language to provide
      information about the document's structure, which is similar to HTML or
      LaTeX and does not require expertise. Alternatively, it can use a simpler,
      "markup-less" format that borrows from Emacs' outline mode and from other
      conventions used in emails, Usenet and text.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: Better Emacs and TeX integration
