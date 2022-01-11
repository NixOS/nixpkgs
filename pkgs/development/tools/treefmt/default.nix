{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    sha256 = "sha256-PTT87Na4KpyN6a7T49vHHhSqSOF6JSWr5/jiys1Uzko=";
  };

  cargoSha256 = "sha256-Gvr6Zjd9Gvn2CyjNHlJaKPFYUViPezRwoDBeVelRlkU=";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
