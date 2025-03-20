{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  openssl,
}:
let
  mkGenealogosPackage =
    {
      crate ? "cli",
    }:
    rustPlatform.buildRustPackage rec {
      pname = "genealogos-${crate}";
      version = "1.0.0";

      src = fetchFromGitHub {
        owner = "tweag";
        repo = "genealogos";
        rev = "v${version}";
        hash = "sha256-EQrKInsrqlpjySX6duylo++2qwglB3EqGfLFJucOQM8=";
        # Genealogos' fixture tests contain valid nix store paths, and are thus incompatible with a fixed-output-derivation.
        # To avoid this, we just remove the tests
        postFetch = ''
          rm -r $out/genealogos/tests/
        '';
      };

      cargoLock = {
        lockFile = ./Cargo.lock;
        outputHashes = {
          "nixtract-0.3.0" = "sha256-fXM6Gle4dt1iJgI6NuPl9l00i5sXGYkE+sUvFdps44s=";
        };
      };

      cargoBuildFlags = [
        "-p"
        "genealogos-${crate}"
      ];
      cargoTestFlags = cargoBuildFlags;

      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ openssl ];

      # Since most tests were removed, just skip testing
      doCheck = false;

      meta = with lib; {
        description = "A Nix sbom generator";
        homepage = "https://github.com/tweag/genealogos";
        license = licenses.mit;
        maintainers = with maintainers; [ erin ];
        changelog = "https://github.com/tweag/genealogos/blob/${src.rev}/CHANGELOG.md";
        mainProgram = "genealogos";
        platforms = lib.platforms.unix;
      };
    };
in
{
  genealogos-cli = mkGenealogosPackage { };
  genealogos-api = mkGenealogosPackage { crate = "api"; };
}
