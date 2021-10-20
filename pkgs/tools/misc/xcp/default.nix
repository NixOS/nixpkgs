{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kwt1qLuP63bIn0VY3oFEcbKh1GGBdObfOmtPV4DMQUU=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoSha256 = "sha256-wFOXRQSOfmGB6Zmkqn7KoK+vyHeFKyGNx7Zf2zzPcE4=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}
