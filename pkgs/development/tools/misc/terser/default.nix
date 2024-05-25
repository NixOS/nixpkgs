{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.31.0";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-rZYzeNBUaimetn/NRugsx6Czc0NxMzAKN58DRcae7pM=";
  };

  npmDepsHash = "sha256-SKL//hww6I3RDkqEUBrM0xDSuoPOCArvKKiBz68JtRo=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
