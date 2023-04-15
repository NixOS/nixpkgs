{ rustPlatform, stdenv, fetchFromGitHub, lib, breakpointHook }: rustPlatform.buildRustPackage {
  pname = "lanzaboote-stub";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "lanzaboote";
    rev = "83a357eb7c261c82e2fa6412216b3c4f8f0d1d18";
    hash = "sha256-jWmTTUejSCa5qO0D/FJMbgXKdFEllRdvA+jG0KX+MfY=";
  };
  sourceRoot = "source/rust/stub";

  cargoHash = "sha256-FlnheCgowYsEHcFMn6k8ESxDuggbO4tNdQlOjUIj7oE=";

  # TODO: limit supported platforms to UEFI
  meta.platforms = lib.platforms.all;

  # `cc-wrapper`/our clang doesn't understand MSVC link opts (hack):
  RUSTFLAGS = "-Clinker=${stdenv.cc.targetPrefix}ld.lld -Clinker-flavor=lld-link";

  # `/`-style parameters are confused for bad paths.
  NIX_ENFORCE_PURITY = 0;
  hardeningDisable = [ "all" ];
  auditable = false;

  # nativeBuildInputs = [ breakpointHook ];

  # Note: broken on i686-uefi: `flush_instruction_cache` is called but not
  # defined
  #
  # TODO(@raitobezarius)
}
