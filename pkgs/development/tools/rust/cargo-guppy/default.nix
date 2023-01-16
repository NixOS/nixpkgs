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
  version = "unstable-2023-01-14";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "d593660fbcbfe50569de5a8aad5bd1ac19885733";
    sha256 = "sha256-5kJTkVAklaSWqGIRjVJX56e8cjxyKAx/2E54OF0mIuw=";
  };

  cargoSha256 = "sha256-H2ta/eH2VzEzHbYs0ugzFseLh0S5lxhB7/wvJEFGj0M=";

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
