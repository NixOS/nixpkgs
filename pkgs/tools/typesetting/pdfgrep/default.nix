{ fetchurl, stdenv, pkgconfig, poppler, poppler_data, makeWrapper }:

stdenv.mkDerivation rec {
  name = "pdfgrep-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/pdfgrep/${version}/${name}.tar.gz";
    sha256 = "6e8bcaf8b219e1ad733c97257a97286a94124694958c27506b2ea7fc8e532437";
  };

  buildInputs = [ pkgconfig poppler poppler_data makeWrapper ];

  patchPhase = ''
    sed -i -e "s%cpp/poppler-document.h%poppler/cpp/poppler-document.h%" pdfgrep.cc
    sed -i -e "s%cpp/poppler-page.h%poppler/cpp/poppler-page.h%" pdfgrep.cc
  '';

  # workarround since it can't be hardcoded in pdfgrep
  preFixup = ''
    wrapProgram "$out/bin/pdfgrep" \
      --set POPPLER_DATADIR "${poppler_data}/share/poppler"
  '';

  meta = {
    description = "a tool to search text in PDF files";
    homepage = http://pdfgrep.sourceforge.net/;
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; linux;
  };
}
