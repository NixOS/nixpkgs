{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "jf";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = "jf";
    rev = "v${version}";
    hash = "sha256-6x/WDsDHkQVjiere17XMY3lxG2M5bmTtdH1rMjii+NY=";
  };

  cargoHash = "sha256-W8/6EiqevF7mX2cgdv9/USVnSVxQ/J6I3Cq/UJyZOxU=";

  meta = with lib; {
    description = "A small utility to safely format and print JSON objects in the commandline";
    homepage = "https://github.com/sayanarijit/jf";
    license = licenses.mit;
    maintainers = [ maintainers.sayanarijit ];
  };
}
