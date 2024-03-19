{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-MHsbwtoiaMBWZi/UHbuhG3VuSSvuQtvxPB9EMMti80A=";
  };

  cargoHash = "sha256-pEXGUIrWZGJoYdNoufXEJ+eeIEhm5JhIUlHRisD4qWc=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
