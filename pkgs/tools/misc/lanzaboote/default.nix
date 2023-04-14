{ rustPlatform, stdenv, fetchFromGitHub, lib }: rustPlatform.buildRustPackage rec {
  pname = "lanzaboote-stub";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "lanzaboote";
    rev = "v${version}";
    hash = "sha256-PHnTsEOF5AzGJyc5E80L2aik3MsZ9G6EjZZg2dkh3vI=";
  };
  sourceRoot = "source/rust/stub";

  cargoHash = "sha256-84KwSNnnW167KiyCgHDk7bDEUlYuS+TGtFKh3sMQOKo=";


  # Needs unstable (TODO: remove this hack):
  RUSTC_BOOTSTRAP = 1;
  # TODO: limit supported platforms to UEFI
  meta.platforms = lib.platforms.all;


  # `cc-wrapper`/our clang doesn't understand MSVC link opts (hack):
  RUSTFLAGS = "-C linker=${stdenv.cc.targetPrefix}ld.lld -C linker-flavor=ld.lld";

  # Note: broken on i686-uefi: `flush_instruction_cache` is called but not
  # defined
  #
  # TODO(@raitobezarius)
}
