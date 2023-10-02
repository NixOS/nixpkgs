{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "2.27.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-yrIZsCxoFV9LFh96asYxpAYv1KvrLq+RlqL8gZXaeak=";
  };

  cargoHash = "sha256-tO49qAEW15q76hLcHOtniwLqGy29MZ/dabyZHYAsiME=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
