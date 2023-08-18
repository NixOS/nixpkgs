{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-/V9xp5ew+oL3AIBsgDaAa6LE5Ko/ae7VW47QATtqG1I=";
  };

  cargoHash = "sha256-pWMsmQ4JqlHgdP5TUgwZ6fwdEjKrilI5Rla6XLjaBF8=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
