{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-lS7+sLA/6ZxieodvSPuEzawxQb2vWdNCkGy1RTbg4dY=";
  };

  cargoHash = "sha256-hGy0B2uLT37wKOvC4/wc8i+v1vEQ3bzrgm/yqRCAx3s=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
