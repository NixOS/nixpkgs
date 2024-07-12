{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "panamax";
  version = "1.0.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-gIgw6JMGpHNXE/PZoz3jRdmjIWy4hETYf24Nd7/Jr/g=";
  };

  cargoHash = "sha256-doEBlUVmXxbuPkDgliWr+LfG5KAMVEGpvLyQpoCzSTc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "Mirror rustup and crates.io repositories for offline Rust and cargo usage";
    mainProgram = "panamax";
    homepage = "https://github.com/panamax-rs/panamax";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
