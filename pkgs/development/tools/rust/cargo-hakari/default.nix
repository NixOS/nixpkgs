{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
  version = "0.9.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-C4UBvxGZDpGfYokTzHQNkUkZqBNuKbE4pzOJ04sTDoY=";
  };

  cargoHash = "sha256-eQrRBmlP206MKDlXxcJ64jD6/6mv3V/sv9TsybIx+8Q=";

  meta = with lib; {
    description = "Manage workspace-hack packages to speed up builds in large workspaces.";
    longDescription = ''
      cargo hakari is a command-line application to manage workspace-hack crates.
      Use it to speed up local cargo build and cargo check commands by 15-95%,
      and cumulatively by 20-25% or more.
    '';
    homepage = "https://crates.io/crates/cargo-hakari";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ macalinao ];
  };
}
