{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.17";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-FgG9sdXZhSlX4p3I9WL5ORN7FCg4Zgt/Y+GRCWhIoP8=";
  };

  cargoHash = "sha256-pYjjiQUnBfZ9wQgXhm4c+A7zMAF9k/Mzl5ccPX407/A=";

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
