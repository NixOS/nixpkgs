{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-license";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-hBlyRk23gRfKdYuVnrFoDE883S32X9DFvTIsR2zfJck=";
  };

  cargoHash = "sha256-4P2kR+Jxki62IdUKpMNL7hzBQWci2tKWrQXV5rkMXkw=";

  meta = with lib; {
    description = "Cargo subcommand to see license of dependencies";
    homepage = "https://github.com/onur/cargo-license";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ basvandijk figsoda matthiasbeyer ];
  };
}
