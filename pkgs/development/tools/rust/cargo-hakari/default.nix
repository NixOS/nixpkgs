{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.25";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "cargo-hakari-${version}";
    sha256 = "sha256-cKnu28L8tjndjtHuClLIpiwTzf6YoN37vw1sE7xrNzQ=";
  };

  cargoHash = "sha256-PoTwS9oS8Nmkdp3ZvdZRdk028SIx6D7kfsiRksyTpKo=";

  cargoBuildFlags = [ "-p" "cargo-hakari" ];
  cargoTestFlags = [ "-p" "cargo-hakari" ];

  meta = with lib; {
    description = "Manage workspace-hack packages to speed up builds in large workspaces.";
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
