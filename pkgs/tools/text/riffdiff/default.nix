{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "2.25.2";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-JZWgI4yAsk+jtTyS3QZBxdAOPYmUxb7pn1SbcUeCh6Y=";
  };

  cargoHash = "sha256-Z33CGF02rPf24LaYh+wEmmGgPPw+oxMNCgMzCrUEKqk=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
