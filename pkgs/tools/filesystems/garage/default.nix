{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitea,
  openssl,
  pkg-config,
  protobuf,
  cacert,
  nixosTests,
}:
let
  generic =
    {
      version,
      hash,
      cargoHash,
      cargoPatches ? [ ],
      eol ? false,
      broken ? false,
    }:
    rustPlatform.buildRustPackage {
      pname = "garage";
      inherit version;

      src = fetchFromGitea {
        domain = "git.deuxfleurs.fr";
        owner = "Deuxfleurs";
        repo = "garage";
        rev = "v${version}";
        inherit hash;
      };

      postPatch = ''
        # Starting in 0.9.x series, Garage is using mold in local development
        # and this leaks in this packaging, we remove it to use the default linker.
        rm .cargo/config.toml || true
      '';

      useFetchCargoVendor = true;
      inherit cargoHash cargoPatches;

      nativeBuildInputs = [
        protobuf
        pkg-config
      ];

      buildInputs = [
        openssl
      ];

      checkInputs = [
        cacert
      ];

      OPENSSL_NO_VENDOR = true;

      # See https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v0.8.2/nix/compile.nix#L192-L198
      # on version changes for checking if changes are required here
      buildFeatures =
        [
          "kubernetes-discovery"
          "bundled-libs"
        ]
        ++ lib.optional (lib.versionOlder version "1.0") "sled"
        ++ [
          "metrics"
          "k2v"
          "telemetry-otlp"
          "lmdb"
          "sqlite"
          "consul-discovery"
        ];

      # To make integration tests pass, we include the optional k2v feature here,
      # but in buildFeatures only for version 0.8+, where it's enabled by default.
      # See: https://garagehq.deuxfleurs.fr/documentation/reference-manual/k2v/
      checkFeatures =
        [
          "k2v"
          "kubernetes-discovery"
          "bundled-libs"
        ]
        ++ lib.optional (lib.versionOlder version "1.0") "sled"
        ++ [
          "lmdb"
          "sqlite"
        ];

      disabledTests = [
        # Upstream told us this test is flakey.
        "k2v::poll::test_poll_item"
      ];

      passthru.tests = nixosTests.garage;

      meta = {
        description = "S3-compatible object store for small self-hosted geo-distributed deployments";
        changelog = "https://git.deuxfleurs.fr/Deuxfleurs/garage/releases/tag/v${version}";
        homepage = "https://garagehq.deuxfleurs.fr";
        license = lib.licenses.agpl3Only;
        maintainers = with lib.maintainers; [
          nickcao
          _0x4A6F
          teutat3s
        ];
        knownVulnerabilities = (lib.optional eol "Garage version ${version} is EOL");
        inherit broken;
        mainProgram = "garage";
      };
    };
in
rec {
  # Until Garage hits 1.0, 0.7.3 is equivalent to 7.3.0 for now, therefore
  # we have to keep all the numbers in the version to handle major/minor/patch level.
  # for <1.0.
  # Please add new versions to nixos/tests/garage/default.nix as well.

  garage_0_8_7 = generic {
    version = "0.8.7";
    hash = "sha256-2QGbR6YvMQeMxN3n1MMJ5qfBcEJ5hjXARUOfEn+m4Jc=";
    cargoHash = "sha256-NmeAkm35Su4o5JEn75pZmxhVHh+VMwKwULKY0eCVlYo=";
    cargoPatches = [ ./update-time-0.8.patch ];
    broken = stdenv.hostPlatform.isDarwin;
  };

  garage_0_9_4 = generic {
    version = "0.9.4";
    hash = "sha256-2ZaxenwaVGYYUjUJaGgnGpZNQprQV9+Jns2sXM6cowk=";
    cargoHash = "sha256-ittesFz1GUGipQecsmMA+GEaVoUY+C9DtEvsO0HFNCc=";
    cargoPatches = [ ./update-time.patch ];
    broken = stdenv.hostPlatform.isDarwin;
  };

  garage_1_1_0 = generic {
    version = "1.1.0";
    hash = "sha256-ysf/GYR39trXTPRdw8uB6E4YDp4nAR8dbU9k9rQTxz0=";
    cargoHash = "sha256-SkDr/e9YZ3raTGucaiv/RV2zF9tEDIeqZeri6Xk3xEU=";
    broken = stdenv.hostPlatform.isDarwin;
  };

  garage_0_8 = garage_0_8_7;

  garage_0_9 = garage_0_9_4;

  garage_1_x = garage_1_1_0;

  garage = garage_1_x;
}
