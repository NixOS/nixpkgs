{ fetchFromGitHub, lib, stdenv, libiconv, texlive, xercesc }:

stdenv.mkDerivation rec {
  pname = "blahtexml";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "gvanas";
    repo = "blahtexml";
    rev = "v${version}";
    hash = "sha256-DL5DyfARHHbwWBVHSa/VwHzNaAx/v7EDdnw1GLOk+y0=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ texlive.combined.scheme-full ]; # scheme-full needed for ucs package
  buildInputs = [ xercesc ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  buildFlags =
    [ "doc" ] ++
    (if stdenv.isDarwin
     then [ "blahtex-mac" "blahtexml-mac" ]
     else [ "blahtex-linux" "blahtexml-linux" ]);

  installPhase = ''
    install -D -t "$out/bin" blahtex blahtexml
    install -m644 -D -t "$doc/share/doc/blahtexml" Documentation/manual.pdf
  '';

  meta = with lib; {
    homepage = "http://gva.noekeon.org/blahtexml/";
    description = "A TeX to MathML converter";
    longDescription = ''
      Blahtex is a program written in C++, which converts an equation given in
      a syntax close to TeX into MathML. It is designed by David Harvey and is
      aimed at supporting equations in MediaWiki.

      Blahtexml is a simple extension of blahtex, written by Gilles Van Assche.
      In addition to the functionality of blahtex, blahtexml has XML processing
      in mind and is able to process a whole XML document into another XML
      document. Instead of converting only one formula at a time, blahtexml can
      convert all the formulas of the given XML file into MathML.
    '';
    license = licenses.bsd3;
    maintainers = [ maintainers.xworld21 ];
    platforms = platforms.all;
  };
}
