{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:
rustPlatform.buildRustPackage rec {
  pname = "rnix-hashes";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = pname;
    rev = "v${version}";
    sha256 = "SzHyG5cEjaaPjTkn8puht6snjHMl8DtorOGDjxakJfA=";
  };

  cargoSha256 = "vaG+0t+XAckV9F4iIgcTkbIUurxdQsTCfOnRnrOKoRc=";

  meta = with lib; {
    broken = true;
    description = "Nix Hash Converter";
    homepage = "https://github.com/numtide/rnix-hashes";
    license = licenses.asl20;
    maintainers = with maintainers; [ rizary ];
  };
}
