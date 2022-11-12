{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.16";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-V4rCtqt3HmvAtanithYAJv9FMt/g2R5JCJUwKITnoV4=";
  };

  cargoHash = "sha256-IGxKIgV7UtPrNAFEzKNJfPiSZ8lW2S2M7AJ7sigCWzQ=";

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
