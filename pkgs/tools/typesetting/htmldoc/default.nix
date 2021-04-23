{ lib, stdenv, fetchFromGitHub, zlib, libpng, SystemConfiguration, Foundation }:

stdenv.mkDerivation rec {
  pname = "htmldoc";
  version = "1.9.11";
  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "htmldoc";
    rev = "v${version}";
    sha256 = "0660829zjfdm6vzx14z7gvsfipsb7h0z74gbkyp2ncg3g2432s4n";
  };
  buildInputs = [ zlib libpng ]
    ++ lib.optionals stdenv.isDarwin [ Foundation SystemConfiguration ];

  meta = with lib; {
    description = "Converts HTML files to PostScript and PDF";
    homepage    = "https://michaelrsweet.github.io/htmldoc";
    license     = licenses.gpl2Only;
    maintainers = with maintainers; [ shanemikel ];
    platforms   = platforms.unix;

    longDescription = ''
      HTMLDOC is a program that reads HTML source files or web pages and
      generates corresponding HTML, PostScript, or PDF files with an optional
      table of contents.
    '';
  };
}
