{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "2.30.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-+bYQrZBbMnlDRZBM252i3dvSpLfW/ys4bBe9mDCvHuU=";
  };

  cargoHash = "sha256-aJc3OcnSE4xo8FdSVt4YYX3i5NZT9GaczlFrbCw+iRo=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
