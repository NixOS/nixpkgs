{
  lib,
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

      # See https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v2.1.0/nix/compile.nix#L71-L78
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

      passthru.tests = nixosTests."garage_${lib.versions.major version}";

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
    version = "1.3.0";
    hash = "sha256-6w+jun0UmQHmoXcokGpPM95BbQyOKefTeAelAFKxNCM=";
    cargoHash = "sha256-mWLsOTWxzMdDfzEDu+WHJ12SVscEVfBVuOTVFbfnk0g=";
  };

  garage_2 = generic {
    version = "2.1.0";
    hash = "sha256-GGwF6kVIJ7MPvO6VRj2ebquJEjJQBwpW18P6L2sGVDs=";
    cargoHash = "sha256-0pT2fqseN1numJZdC0FFg1JXbDq1YmlmBPQVbOpxtkw=";
  };

  garage = garage_1;
}
