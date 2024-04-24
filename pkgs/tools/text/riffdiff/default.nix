{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-ASIB7+ZyvMsaRdvJcWT/sR0JLyt4v/gytAIi8Yajlzg=";
  };

  cargoHash = "sha256-NGTWBlg5xvodK02RtFuCe7KsFm4z2aEpbcx3UqH9G/o=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
