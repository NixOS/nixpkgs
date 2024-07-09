{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.28";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "cargo-hakari-${version}";
    sha256 = "sha256-mTemccM/C9M2kso9PNpd0UGEZJd/tBd1PjCpbDFFtNo=";
  };

  cargoHash = "sha256-UaSW9PZMUhqjvRM0/URHaOfofG5Ap3bvKgAHa+H+MFw=";

  cargoBuildFlags = [ "-p" "cargo-hakari" ];
  cargoTestFlags = [ "-p" "cargo-hakari" ];

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
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda macalinao ];
  };
}
