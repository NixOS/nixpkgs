{ lib, rustPlatform, fetchCrate, libbfd, libopcodes, libunwind }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bolero";
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-BuqbM55P/st+4XUSCwrqILUUCfwvSlxhKQFO+IZLa8U=";
  };

  cargoSha256 = "sha256-+TxMOKoId13meXqmr1QjDZMNqBnPEDQF1VSPheq8Ji0=";

  buildInputs = [ libbfd libopcodes libunwind ];

  meta = with lib; {
    description = "Fuzzing and property testing front-end framework for Rust";
    homepage = "https://github.com/camshaft/bolero";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
  };
}
