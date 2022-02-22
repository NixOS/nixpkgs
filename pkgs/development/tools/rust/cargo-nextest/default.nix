{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-uW9GenS/yf5mdu97/pbfaoR9mGh1kIX+sUYRvIIGBjw=";
  };

  cargoSha256 = "sha256-A7EWzk5x0S0RP/O8Jhliq3KuaV0OEci160KQisaj0RI=";
  cargoDepsName = pname;

  meta = with lib; {
    description = "A next-generation test runner for Rust";
    homepage = "https://nexte.st";
    license = licenses.asl20;
    maintainers = with maintainers; [ jacg ];
  };
}
