{ lib
, rustPlatform
, fetchFromGitHub
, testers
, hex
}:

rustPlatform.buildRustPackage rec {
  pname = "hex";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "sitkevij";
    repo = "hex";
    rev = "v${version}";
    hash = "sha256-mxKjiciejnOTbSkCzOWdAtysRAnEv4JgntPS1qM9og8=";
  };

  cargoHash = "sha256-kGe6XN03V+ILnlAcT0E8BvrYMa7ub05STFsFY6X5Gkk=";

  passthru.tests.version = testers.testVersion {
    package = hex;
    version = "hx ${version}";
  };

  meta = with lib; {
    description = "Futuristic take on hexdump, made in Rust";
    homepage = "https://github.com/sitkevij/hex";
    changelog = "https://github.com/sitkevij/hex/releases/tag/v${version}";
    mainProgram = "hx";
    license = licenses.mit;
    maintainers = with maintainers; [ ivar ];
  };
}
