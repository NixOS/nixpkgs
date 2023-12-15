{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "2.27.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-cW43nt8Go4VjEwXpCieGYIXwG1XMexslgriMsZ0BB1g=";
  };

  cargoHash = "sha256-phTo0XvCiTnBFF5r5myvwmiWnpcYLnkaMLcaXw4oL/Y=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
