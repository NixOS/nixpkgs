{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "proton-caller";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "caverym";
    repo = pname;
    rev = version;
    sha256 = "sha256-GFZX+ss6LRosCsOuzjLu15BCdImhxH2D2kZQzF8zA90=";
  };

  cargoSha256 = "sha256-8HaMmvSUI5Zttlsx5tewwIR+iKBlp4w8XlRfI0tyBas=";

  meta = with lib; {
    description = "Run Windows programs with Proton";
    changelog = "https://github.com/caverym/proton-caller/releases/tag/${version}";
    homepage = "https://github.com/caverym/proton-caller";
    license = licenses.mit;
    maintainers = with maintainers; [ kho-dialga ];
  };
}
