{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-binutils";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1sJ+vi78lZsYEQBDyUzifdiU47R1Z6Y8ejNI9h5U+Ao=";
  };

  cargoSha256 = "sha256-kZhxKwSEI24LNJ9lPPjtX5etE0XeqaVN7h3HTzpoAY0=";

  meta = with lib; {
    description = "Cargo subcommands to invoke the LLVM tools shipped with the Rust toolchain";
    longDescription = ''
      In order for this to work, you either need to run `rustup component add llvm-tools-preview` or install the `llvm-tools-preview` component using your Nix library (e.g. nixpkgs-mozilla, or rust-overlay)
    '';
    homepage = "https://github.com/rust-embedded/cargo-binutils";
    changelog = "https://github.com/rust-embedded/cargo-binutils/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ stupremee ];
  };
}
