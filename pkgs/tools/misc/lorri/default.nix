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
  version = "unstable-2020-01-09";

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
    rev = "7b84837b9988d121dd72178e81afd440288106c5";
    sha256 = "0rkga944jl6i0051vbsddfqbvzy12168cbg4ly2ng1rk0x97dbr8";
  };

  cargoSha256 = "0k7l0zhk2vzf4nlwv4xr207irqib2dqjxfdjk1fprff84c4kblx8";
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
