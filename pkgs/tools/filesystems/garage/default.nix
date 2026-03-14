{
  lib,
  rustPlatform,
  fetchFromGitea,
  openssl,
  pkg-config,
  protobuf,
  cacert,
  nix-update-script,
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

      env.OPENSSL_NO_VENDOR = true;

      # See https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v2.2.0/nix/compile.nix#L71-L78
      # on version changes for checking if changes are required here
      buildFeatures = [
        "bundled-libs"
        "consul-discovery"
        "fjall"
        "journald"
        "k2v"
        "kubernetes-discovery"
        "lmdb"
        "metrics"
        "sqlite"
        "syslog"
        "telemetry-otlp"
      ];

      passthru = {
        tests = nixosTests."garage_${lib.versions.major version}";
        updateScript = nix-update-script {
          extraArgs = [
            "--version-regex"
            "v(${lib.versions.major version}\\.[0-9.]+)"
          ];
        };
      };

      meta = {
        description = "S3-compatible object store for small self-hosted geo-distributed deployments";
        changelog = "https://git.deuxfleurs.fr/Deuxfleurs/garage/releases/tag/v${version}";
        homepage = "https://garagehq.deuxfleurs.fr";
        license = lib.licenses.agpl3Only;
        maintainers = with lib.maintainers; [
          adamcstephens
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
  garage_1 = generic {
    version = "1.3.1";
    hash = "sha256-wkCnJmbulnhzwHvzdpzh9MRceOzmPdhOogffwhqNGPg=";
    cargoHash = "sha256-jfYe2A6zkVgTLrWBDbahICSKCRO3FwsBPNSVFapH0Rs=";
  };

  garage_2 = generic {
    version = "2.2.0";
    hash = "sha256-UaWHZPV0/Jgeiwvvr9V9Gqthn5KXErLx8gL4JdBRDVs=";
    cargoHash = "sha256-U6Wipvlw3XdKUBNZMznENJ9m+9fzP9Nb6217+Kytu7s=";
  };

  garage = garage_1;
}
