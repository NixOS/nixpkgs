{ stdenv
, pkgs
, fetchFromGitHub
, rustPlatform
  # Updater script
, runtimeShell
, writers
  # Tests
, nixosTests
  # Apple dependencies
, CoreServices
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lorri";
  version = "1.1";

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
    # ALSO don’t forget to update the cargoSha256!
    rev = "93d93013217cd9aa09d2bd316d6c3abf827a6601";
    sha256 = "0wbkx8hmikngfp6fp0y65yla22f3k0jszq8a6pas80q0b33llwm5";
  };

  cargoSha256 = "1a3n1ylyp63x6v7b07nnqpfxjzmsgwmgraza23lx8z4gh167gv46";
  doCheck = false;

  BUILD_REV_COUNT = src.revCount or 1;
  RUN_TIME_CLOSURE = pkgs.callPackage ./runtime.nix {};

  nativeBuildInputs = with pkgs; [ rustPackages.rustfmt ];
  buildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

  passthru = {
    updater = writers.writeBash "copy-runtime-nix.sh" ''
      set -euo pipefail
      cp ${src}/nix/runtime.nix ${toString ./runtime.nix}
      cp ${src}/nix/runtime-closure.nix.template ${toString ./runtime-closure.nix.template}
    '';
    tests = {
      nixos = nixosTests.lorri;
    };
  };
}
