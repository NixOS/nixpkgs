{ lib, rustPlatform, fetchCrate, libbfd, libopcodes, libunwind }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bolero";
<<<<<<< HEAD
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-BuqbM55P/st+4XUSCwrqILUUCfwvSlxhKQFO+IZLa8U=";
  };

  cargoSha256 = "sha256-+TxMOKoId13meXqmr1QjDZMNqBnPEDQF1VSPheq8Ji0=";
=======
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-j6fWCIXfVS5b3NZizhg9pI+kJkWlR1eGUSW9hJO1/mQ=";
  };

  cargoSha256 = "sha256-ycvGw99CcE29axG9UWD0lkQp5kxD6Eguco5Fh9Vfj6E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ libbfd libopcodes libunwind ];

  meta = with lib; {
    description = "Fuzzing and property testing front-end framework for Rust";
    homepage = "https://github.com/camshaft/bolero";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
  };
}
