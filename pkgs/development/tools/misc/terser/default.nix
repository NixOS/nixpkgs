{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.19.3";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-ZI5ElHnQwoCJspGL/v0PqddMUAAhQGWDZA9utWZD/nM=";
  };

  npmDepsHash = "sha256-M7LGXoZFBQrXpkiofnam7tgFkk6+N7ckPxTcwAAuqxU=";

  meta = with lib; {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    homepage = "https://terser.org";
    license = licenses.bsd2;
    maintainers = with maintainers; [ talyz ];
  };
}
