{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  Cocoa,
  Foundation,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watch";
  version = "8.5.3";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-agwK20MkvnhqSVAWMy3HLkUJbraINn12i6VAg8mTzBk=";
  };

  cargoHash = "sha256-oqGc5haN8Jyi0eQf8egrRXWxi0RGVdIFhpGKgmFB8DI=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Foundation
    Cocoa
  ];

  NIX_LDFLAGS = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "-framework"
    "AppKit"
  ];

  # `test with_cargo` tries to call cargo-watch as a cargo subcommand
  # (calling cargo-watch with command `cargo watch`)
  preCheck = ''
    export PATH="$(pwd)/target/${stdenv.hostPlatform.rust.rustcTarget}/release:$PATH"
  '';

  meta = with lib; {
    description = "Cargo subcommand for watching over Cargo project's source";
    mainProgram = "cargo-watch";
    homepage = "https://github.com/watchexec/cargo-watch";
    license = licenses.cc0;
    maintainers = with maintainers; [
      xrelkd
      ivan
      matthiasbeyer
    ];
  };
}
