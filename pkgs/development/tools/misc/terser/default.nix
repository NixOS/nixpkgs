{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.30.0";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-d3vnCEb9HzydpxsuoX66KqUtgYYt/+L2AcpZNFDleoY=";
  };

  npmDepsHash = "sha256-wrxa6/TKYb/pqT4zjTVbfONSYqko12pVzBQ9Ojm7H2o=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
