{
  stdenv,
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "lanzaboote-stub";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "lanzaboote";
    rev = "v${version}";
    hash = "sha256-Fb5TeRTdvUlo/5Yi2d+FC8a6KoRLk2h1VE0/peMhWPs=";
  };

  sourceRoot = "source/rust/stub";
  cargoHash = "sha256-FlnheCgowYsEHcFMn6k8ESxDuggbO4tNdQlOjUIj7oE=";

  # Necessary because our `cc-wrapper` doesn't understand MSVC link options.
  # -flavor link which will break the whole command-line processing for the ld.lld linker.
  RUSTFLAGS = "-Clinker=${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}lld-link -Clinker-flavor=lld-link";
  # Does not support MSVC style options yet (?).
  auditable = false;
  hardeningDisable = [
    "relro"
    "bindnow"
  ];

  meta = with lib; {
    description = "Lanzaboote UEFI stub for SecureBoot enablement on NixOS systems";
    homepage = "https://github.com/nix-community/lanzaboote";
    license = licenses.gpl3Only;
    mainProgram = "lanzaboote_stub.efi";
    hydraPlatforms = [ lib.systems.inspect.platformPatterns.isUefi ];
    # i686: Builtins errors
    # aarch64: compile fine but unable to test on real hardware
    broken = with stdenv.hostPlatform; isi686 || isAarch64;
    maintainers = with maintainers; [
      raitobezarius
      nikstur
      blitz
    ];
  };
}
