{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "conserve";
  version = "23.11.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "conserve";
    rev = "v${version}";
    hash = "sha256-Ck2+3etwfZiDMZHzI2hIBuUKn7L0ZTGEe9yJjXjoRIM=";
  };

  cargoHash = "sha256-tMj1icGNTFpouts1TE6BIiABexV3vmOW9r5Y/7ynUMM=";

  meta = with lib; {
    description = "Robust portable backup tool in Rust";
    homepage = "https://github.com/sourcefrog/conserve";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "conserve";
  };
}
