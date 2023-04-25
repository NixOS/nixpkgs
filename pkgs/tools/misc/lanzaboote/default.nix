{ rustPlatform, stdenv, fetchFromGitHub, lib }:
rustPlatform.buildRustPackage {
  pname = "lanzaboote-stub";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "lanzaboote";
    rev = "b21c4007afaf461834da091afe7ba8b37331de65";
    hash = "sha256-WmuqqaHfDEXoNDcZ7jT4XdOxJqVbbVFZa89BtmLMENQ=";
  };
  sourceRoot = "source/rust/stub";

  cargoHash = lib.fakeHash;

  # `cc-wrapper`/our clang doesn't understand MSVC link opts (hack):
  # RUSTFLAGS = "-Clinker=${stdenv.cc.targetPrefix}ld.lld -Clinker-flavor=lld-link";

  # TODO: limit supported platforms to UEFI
  meta.platforms = lib.platforms.all;
}
