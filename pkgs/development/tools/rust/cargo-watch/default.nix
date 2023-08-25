{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Cocoa
, CoreServices
, Foundation
, rust
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "8.4.0";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YwiTzIO60ct076vMoK9BHKa65Qet2PAvPRwnZcjDgcM=";
  };

  cargoHash = "sha256-BzcKWQSB94H3XOsbwNvJoAHlZwkJvLABIrfFh9Ugfig=";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa CoreServices Foundation libiconv ];

  # `test with_cargo` tries to call cargo-watch as a cargo subcommand
  # (calling cargo-watch with command `cargo watch`)
  preCheck = ''
    export PATH="$(pwd)/target/${rust.toRustTarget stdenv.hostPlatform}/release:$PATH"
  '';

  meta = with lib; {
    description = "A Cargo subcommand for watching over Cargo project's source";
    homepage = "https://github.com/watchexec/cargo-watch";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ivan matthiasbeyer ];
  };
}
