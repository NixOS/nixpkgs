{ lib, stdenv, fetchurl, pkg-config, poppler, libgcrypt, pcre, asciidoc }:

stdenv.mkDerivation rec {
  pname = "pdfgrep";
  version = "2.1.2";

  src = fetchurl {
    url = "https://pdfgrep.org/download/${pname}-${version}.tar.gz";
    sha256 = "1fia10djcxxl7n9jw2prargw4yzbykk6izig2443ycj9syhxrwqf";
  };

  postPatch = ''
    for i in ./src/search.h ./src/pdfgrep.cc ./src/search.cc; do
      substituteInPlace $i --replace '<cpp/' '<'
    done
  '';

  configureFlags = [
    "--with-libgcrypt-prefix=${lib.getDev libgcrypt}"
  ];

  nativeBuildInputs = [ pkg-config asciidoc ];
  buildInputs = [ poppler libgcrypt pcre ];

  meta = {
    description = "Commandline utility to search text in PDF files";
    homepage = "https://pdfgrep.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qknight fpletz ];
    platforms = with lib.platforms; unix;
    mainProgram = "pdfgrep";
  };
}
