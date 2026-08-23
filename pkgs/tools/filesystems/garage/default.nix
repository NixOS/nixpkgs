{
  lib,
  rustPlatform,
  fetchFromGitea,
  fetchpatch2,
  installShellFiles,
  openssl,
  pkg-config,
  protobuf,
  cacert,
  nix-update-script,
  nixosTests,
  stdenv,
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
        installShellFiles
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

      # See https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v2.3.0/nix/compile.nix#L71-L78
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

      postInstall =
        lib.optionalString
          ((lib.versionAtLeast version "2.3.0") && (stdenv.buildPlatform.canExecute stdenv.hostPlatform))
          ''
            installShellCompletion --cmd garage \
              --bash <($out/bin/garage completions bash) \
              --fish <($out/bin/garage completions fish) \
              --zsh <($out/bin/garage completions zsh)
          '';

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
    version = "2.3.0";
    hash = "sha256-CqHcaVGgXL/jjqq7XN+kzEp6xoNgwBfGpMKYbTd78Ys=";
    cargoHash = "sha256-ANh97G/2/KtCMN4gldteq6ROduk1AQJkI5zS9n97OJY=";
    cargoPatches = [
      (fetchpatch2 {
        # fix: prevent depending on aws-lc via reqwest
        url = "https://git.deuxfleurs.fr/Deuxfleurs/garage/commit/7c18abb664d891cdb696b478058b7506e3d53f44.patch";
        hash = "sha256-f/+vDOC+kcmJVLtx1Y6OepoJBZhX30DULwSLnyQN5aI=";
      })
    ];
  };

  garage = garage_1;
}
