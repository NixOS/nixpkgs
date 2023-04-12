{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-guppy";
  version = "unstable-2023-01-19";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "0f2e0627d430fa6488980f2808c472ae406d3603";
    sha256 = "sha256-7ADq5yDVpYn91K/rbXWxp0+34twQ8LArD+vVd48tee4=";
  };

  cargoSha256 = "sha256-oVG3x0yGTqNKMaqkOJhfhqRWNwAkUgfkGr7Vxr+nY4I=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "-p" "cargo-guppy" ];
  cargoTestFlags = [ "-p" "cargo-guppy" ];

  meta = with lib; {
    description = "A command-line frontend for guppy";
    homepage = "https://github.com/guppy-rs/guppy/tree/main/cargo-guppy";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
