{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.28.1";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-iThO12jPzwCyfi69Z0YpttRxhVnSVirKbttN6R5iqRg=";
  };

  npmDepsHash = "sha256-CptJkwC0A03v2CeYSCKXq7fOhPdLWPrVJYpayzKbdkQ=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
