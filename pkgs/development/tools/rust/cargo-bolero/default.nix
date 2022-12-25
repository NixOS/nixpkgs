{ lib, rustPlatform, fetchCrate, libbfd, libopcodes, libunwind }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bolero";
  version = "0.6.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-fyXXYV5X9t5biw1byWd1B2eQaPxdQPFWe3kVrLth2Ns=";
  };

  cargoSha256 = "sha256-g8WeDqv5o4GKAd32+SJGLHl/cozWTVrrj1vWwvxX8Bw=";

  buildInputs = [ libbfd libopcodes libunwind ];

  meta = with lib; {
    description = "Fuzzing and property testing front-end framework for Rust";
    homepage = "https://github.com/camshaft/bolero";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
  };
}
