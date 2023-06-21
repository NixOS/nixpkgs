{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-pack";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-pack";
    rev = "refs/tags/v${version}";
    hash = "sha256-Sfcf/Dko2lAfkfYdeanLAqhbUgeKtGBxx4timZi2kCk=";
  };

  cargoHash = "sha256-bl1KDFNvpNtkbKqiBRbmQLo1/oqLl7u7gNHLhhm8ETI=";

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # Most tests rely on external resources and build artifacts.
  # Disabling check here to work with build sandboxing.
  doCheck = false;

  meta = with lib; {
    description = "A utility that builds rust-generated WebAssembly package";
    homepage = "https://github.com/rustwasm/wasm-pack";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dhkl ];
  };
}
