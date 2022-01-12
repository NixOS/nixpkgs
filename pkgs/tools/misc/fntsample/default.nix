{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, pkg-config
, cairo
, fontconfig
, freetype
, glib
, libXdmcp
, makeWrapper
, pango
, pcre
, perlPackages
}:

let
  ucd-blocks = fetchurl {
    url = "https://www.unicode.org/Public/14.0.0/ucd/Blocks.txt";
    hash = "sha256-WYhw3d73s0talykWUoxFav8nZbec1Plkf7WM63Z+fxc=";
  };
in
stdenv.mkDerivation rec {
  pname = "fntsample";
  version = "5.4";

  src = fetchFromGitHub {
    owner = "eugmes";
    repo = pname;
    rev = "release/${version}";
    hash = "sha256-O5RT68wPWwzCb51JZWWNcIubWoM7NZw/MRiaHXPDmF0=";
  };

  cmakeFlags = [
    "-DUNICODE_BLOCKS=${ucd-blocks.outPath}"
  ];

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    glib
    libXdmcp
    pango
    perlPackages.perl
    pcre
  ];

  postFixup =
    let
      perlPath = with perlPackages; makePerlPath [
        ExporterTiny
        ListMoreUtils
        PDFAPI2
        libintl-perl
      ];
    in ''
    for cmd in pdfoutline pdf-extract-outline; do
      wrapProgram "$out/bin/$cmd" --prefix PERL5LIB : "${perlPath}"
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/eugmes/fntsample";
    description = "PDF and PostScript font samples generator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
# TODO: factor/package ucd-blocks
