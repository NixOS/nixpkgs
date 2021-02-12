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

  cargoSha256 = "W1sp2VeGVg0SQYARXKRl0cp8UHLFXevNdiADDcKn1VA=";

  meta = with lib; {
    description = "Nix Hash Converter";
    homepage = "https://github.com/numtide/rnix-hashes";
    license = licenses.asl20;
    maintainers = with maintainers; [ rizary ];
  };
}
