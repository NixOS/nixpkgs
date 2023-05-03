{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "raphlinus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AAb+dSJ1oSRuvWu47VvzCeB6pQE6/+u69io2FsZoZHM=";
  };

  cargoHash = "sha256-oOgwZMmrzYBFH1MaE7nMa1SPCACnfqYY3ttOECsnsVY=";

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
}
