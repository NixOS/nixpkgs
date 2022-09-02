{ fetchFromGitHub
, lib
, rustPlatform
, pkg-config
, openssl
, zlib
, stdenv
, git
, IOKit
, Security
, CoreFoundation
, AppKit
, System
  # Prover dependencies
, z3_4_11
, icu
, boogie
, dotnet-sdk
, callPackage
, wrapWithMoveProverDeps
}:

let
  # Tests only pass on Z3 4.11.
  z3 = z3_4_11;
  # `dotnet-sdk` only works on 64-bit systems, so we can't run
  # the Move prover on `i686`.
  # Exclude Move prover tests until z3 4.11 is on Nixpkgs
  installProver = !stdenv.isi686;

  common = { buildFeatures ? [ ] }:
    let
      # Default to not running tests.
      # Tests do not pass with the `address20` or `address32` features enabled, since
      # expected outputs were generated with no features. (16 byte addresses)
      # We should run tests on `move-cli` with no features enabled.
      doCheck = (builtins.length buildFeatures) == 0;
      package = rustPlatform.buildRustPackage rec {
        inherit buildFeatures doCheck;

        pname = "move";
        version = "unstable-2022-08-28";
        src = fetchFromGitHub {
          owner = "move-language";
          repo = "move";
          rev = "bc57bf2df7aee3f639ec670af5c6ff5341d89a9d";
          sha256 = "sha256-4BCwDTfdH8TTeF+zJyea3WsoU0YGgGSS1B3FxEZ6Ulk=";
        };

        cargoSha256 = "sha256-BTbChMtwSD5GIHLXUaEMlk3PMMh7jgR9yWk2W4J4El8=";

        nativeBuildInputs = [ pkg-config ];
        buildInputs = [ openssl zlib git ] ++ (lib.optionals stdenv.isDarwin ([
          IOKit
          Security
          CoreFoundation
          AppKit
        ] ++ (lib.optionals stdenv.isAarch64 [ System ])))
          ++ (lib.optionals installProver [
          z3
          icu
          boogie
          dotnet-sdk
        ]);

        # Set $MOVE_HOME to $TMPDIR to prevent tests from writing to the home directory.
        preCheck = ''
          export MOVE_HOME=$TMPDIR
          ${lib.optionalString installProver ''
            export BOOGIE_EXE=${boogie}/bin/boogie
            export Z3_EXE=${z3}/bin/z3
            export DOTNET_ROOT=${dotnet-sdk}
            export LD_LIBRARY_PATH=${icu}/lib
          ''}
        '';

        # We want to check with `--profile ci`, so we use `--debug` here to get rid of the
        # `--release` flag.
        checkType = "debug";
        cargoTestFlags = [
          "--workspace"
          "--profile"
          "ci"
          # Ignore Solidity tests since they require a specific version of Solc.
          "--exclude"
          "evm-exec-utils"
          "--exclude"
          "move-to-yul"
        ] ++ (lib.optionals (!installProver) [
          "--exclude"
          "move-prover"
        ]);
        cargoCheckFlags = lib.optionals (!installProver) [
          "--skip"
          "prove"
        ];

        meta = with lib; {
          description = "CLI frontend for the Move compiler and VM";
          longDescription = ''
            Move is a programming language for writing safe smart contracts originally
            developed at Facebook to power the Diem blockchain. Move is designed to be
            a platform-agnostic language to enable common libraries, tooling, and
            developer communities across diverse blockchains with vastly different
            data and execution models.
          '';
          homepage = "https://github.com/move-language/move";
          license = licenses.asl20;
          maintainers = with maintainers; [ macalinao ];
        };
      };
    in
    wrapWithMoveProverDeps {
      inherit package;
      bin = "move";
    };
in
rec {
  move-cli = common { };
  move-cli-address20 = common {
    buildFeatures = [ "address20" ];
  };
  move-cli-address32 = common {
    buildFeatures = [ "address32" ];
  };
}
