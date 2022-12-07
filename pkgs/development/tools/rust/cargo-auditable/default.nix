{ lib, fetchFromGitHub, makeRustPlatform, rustc, cargo }:

let
  args = rec {
    pname = "cargo-auditable";
    version = "unstable-2022-12-07";

    src = fetchFromGitHub {
      owner = "rust-secure-code";
      repo = pname;
      rev = "246468da22d619c816227797fb176c44026c7105";
      sha256 = "sha256-tZ6qA20TM+mZa2bYWWdFeM+6104e+hVE9Swst2n6Mx8=";
    };

    cargoSha256 = "sha256-LkFP/m/pTIDnIueNDwM89lk7FNXnT4Fl8EIdXgR9oOg=";

    meta = with lib; {
      description = "A tool to make production Rust binaries auditable";
      homepage = "https://github.com/rust-secure-code/cargo-auditable";
      changelog = "https://github.com/rust-secure-code/cargo-auditable/blob/v${version}/cargo-auditable/CHANGELOG.md";
      license = with licenses; [ mit /* or */ asl20 ];
      maintainers = with maintainers; [ figsoda ];
    };
  };

  rustPlatform = makeRustPlatform {
    inherit rustc;
    cargo = cargo.override {
      auditable = false;
    };
  };

  bootstrap = rustPlatform.buildRustPackage (args // {
    auditable = false;
  });
in

rustPlatform.buildRustPackage.override { cargo-auditable = bootstrap; } (args // {
  auditable = true; # TODO: remove when this is the default
})
