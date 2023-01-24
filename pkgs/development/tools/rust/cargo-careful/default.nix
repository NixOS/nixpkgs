{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-kKF/Fp6RCF9PUdgqeo2e4vLVhl8+5M4oa0Q18ZdXJRc=";
  };

  cargoHash = "sha256-rhTi4rHfU+ZgNAMXSX7r5k3NfMUPNjHIUDs6FzeqcWk=";

  meta = with lib; {
    description = "A tool to execute Rust code carefully, with extra checking along the way";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
