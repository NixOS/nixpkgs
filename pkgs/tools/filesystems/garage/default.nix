{ lib, stdenv, rustPlatform, fetchFromGitea, openssl, pkg-config, protobuf
, testers, Security, garage, nixosTests }:
let
  generic = { version, sha256, cargoSha256, eol ? false, broken ? false }: rustPlatform.buildRustPackage {
    pname = "garage";
    inherit version;

    src = fetchFromGitea {
      domain = "git.deuxfleurs.fr";
      owner = "Deuxfleurs";
      repo = "garage";
      rev = "v${version}";
      inherit sha256;
    };

    inherit cargoSha256;

    nativeBuildInputs = [ protobuf pkg-config ];

    buildInputs = [
      openssl
    ] ++ lib.optional stdenv.isDarwin Security;

    OPENSSL_NO_VENDOR = true;

    # See https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v0.7.2/default.nix#L84-L98
    # on version changes for checking if changes are required here
    buildFeatures = [
      "kubernetes-discovery"
    ] ++
    (lib.optional (lib.versionAtLeast version "0.8") [
      "bundled-libs"
      "sled"
      "metrics"
      "k2v"
      "telemetry-otlp"
      "lmdb"
      "sqlite"
    ]);

    # To make integration tests pass, we include the optional k2v feature here,
    # but not in buildFeatures. See:
    # https://garagehq.deuxfleurs.fr/documentation/reference-manual/k2v/
    checkFeatures = [
      "k2v"
      "kubernetes-discovery"
    ] ++
    (lib.optional (lib.versionAtLeast version "0.8") [
      "bundled-libs"
      "sled"
      "metrics"
      "telemetry-otlp"
      "lmdb"
      "sqlite"
    ]);

    passthru = nixosTests.garage;

    meta = {
      description = "S3-compatible object store for small self-hosted geo-distributed deployments";
      homepage = "https://garagehq.deuxfleurs.fr";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ nickcao _0x4A6F teutat3s raitobezarius ];
      knownVulnerabilities = (lib.optional eol "Garage version ${version} is EOL");
      inherit broken;
    };
  };
in
  rec {
    # Until Garage hits 1.0, 0.7.3 is equivalent to 7.3.0 for now, therefore
    # we have to keep all the numbers in the version to handle major/minor/patch level.
    # for <1.0.

    garage_0_7_3 = generic {
      version = "0.7.3";
      sha256 = "sha256-WDhe2L+NalMoIy2rhfmv8KCNDMkcqBC9ezEKKocihJg=";
      cargoSha256 = "sha256-5m4c8/upBYN8nuysDhGKEnNVJjEGC+yLrraicrAQOfI=";
      eol = true; # Confirmed with upstream maintainers over Matrix.
    };

    garage_0_7 = garage_0_7_3;

    garage_0_8_0 = generic {
      version = "0.8.0";
      sha256 = "sha256-c2RhHfg0+YV2E9Ckl1YSc+0nfzbHPIt0JgtT0DND9lA=";
      cargoSha256 = "sha256-vITXckNOiJbMuQW6/8p7dsZThkjxg/zUy3AZBbn33no=";
      # On x86_64-darwin, tests are failing.
      broken = stdenv.isDarwin && stdenv.isx86_64;
    };

    garage_0_8 = garage_0_8_0;

    garage = garage_0_8;
  }
