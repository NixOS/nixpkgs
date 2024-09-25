{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.30";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "cargo-hakari-${version}";
    sha256 = "sha256-fwqMV8oTEYqS0Y/IXar1DSZ0Gns1qJ9oGhbdehScrgw=";
  };

  cargoHash = "sha256-DkPnQcoiytIYz780veSAhPnk70qkP3QvTJJ41csUThY=";

  cargoBuildFlags = [
    "-p"
    "cargo-hakari"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-hakari"
  ];

  meta = with lib; {
    description = "Manage workspace-hack packages to speed up builds in large workspaces";
    mainProgram = "cargo-hakari";
    longDescription = ''
      cargo hakari is a command-line application to manage workspace-hack crates.
      Use it to speed up local cargo build and cargo check commands by 15-95%,
      and cumulatively by 20-25% or more.
    '';
    homepage = "https://crates.io/crates/cargo-hakari";
    changelog = "https://github.com/guppy-rs/guppy/blob/cargo-hakari-${version}/tools/cargo-hakari/CHANGELOG.md";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      macalinao
    ];
  };
}
