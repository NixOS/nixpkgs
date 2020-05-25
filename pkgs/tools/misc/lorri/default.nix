{ stdenv
, pkgs
, fetchFromGitHub
, rustPlatform
  # Updater script
, runtimeShell
, writeScript
  # Tests
, nixosTests
  # Apple dependencies
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lorri";
  version = "1.0";

  meta = with stdenv.lib; {
    description = "Your project's nix-env";
    homepage = "https://github.com/target/lorri";
    license = licenses.asl20;
    maintainers = with maintainers; [ grahamc Profpatsch ];
  };

  src = fetchFromGitHub {
    owner = "target";
    repo = pname;
    # Run `eval $(nix-build -A lorri.updater)` after updating the revision!
    rev = "88c680c9abf0f04f2e294436d20073ccf26f0781";
    sha256 = "1415mhdr0pwvshs04clfz1ys76r5qf9jz8jchm63l6llaj6m7mrv";
  };

  cargoSha256 = "1iwd0cad8dp8q5xz2mm7zn1wphr5brkw937dfygc88afj6bv3d68";
  doCheck = false;

  BUILD_REV_COUNT = src.revCount or 1;
  RUN_TIME_CLOSURE = pkgs.callPackage ./runtime.nix {};

  nativeBuildInputs = with pkgs; [ rustPackages.rustfmt ];
  buildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

  passthru = {
    updater = with builtins; writeScript "copy-runtime-nix.sh" ''
      #!${runtimeShell}
      set -euo pipefail
      cp ${src}/nix/runtime.nix ${toString ./runtime.nix}
      cp ${src}/nix/runtime-closure.nix.template ${toString ./runtime-closure.nix.template}
    '';
    tests = {
      nixos = nixosTests.lorri;
    };
  };
}
