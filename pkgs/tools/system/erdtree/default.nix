{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gZC90flsfH03Grc1netzlv/iX/9DH+rpaSstfXFearc=";
  };

  cargoHash = "sha256-0I60lUYyR4Za2Q3FqcdqJhUKFjX5+PE88G6JxxxiBXw=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
