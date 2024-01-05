{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Cocoa
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "8.5.1";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MzwifQsOSJt9wq8bhVAY6HqXP4Zs4+a2GcG79PdAiMY=";
  };

  cargoHash = "sha256-wyyIZ7i1icvD53hnUM4H/kvxj6K/pVzAAvKKp5LzwTE=";

  buildInputs = lib.optionals stdenv.isDarwin [ Foundation Cocoa ];

  NIX_LDFLAGS = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "-framework" "AppKit" ];

  # `test with_cargo` tries to call cargo-watch as a cargo subcommand
  # (calling cargo-watch with command `cargo watch`)
  preCheck = ''
    export PATH="$(pwd)/target/${stdenv.hostPlatform.rust.rustcTarget}/release:$PATH"
  '';

  meta = with lib; {
    description = "A Cargo subcommand for watching over Cargo project's source";
    homepage = "https://github.com/watchexec/cargo-watch";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ivan matthiasbeyer ];
  };
}
