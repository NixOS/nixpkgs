{ fetchFromGitHub, lib, stdenv, libiconv, texlive, xercesc }:

stdenv.mkDerivation {
  pname = "blahtexml";
  version = "0.9+date=2020-05-16";

  src = fetchFromGitHub {
    owner = "gvanas";
    repo = "blahtexml";
    rev = "92f2c5ff1f2b00a541b2222facc51ec72e5f6559";
    hash = "sha256-ts+2gWsp7+rQu1US2/qEdbttB2Ps12efTSrcioZYsmE=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ texlive.combined.scheme-full ];
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
