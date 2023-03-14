{ lib, stdenv, rustPlatform, fetchFromGitea, openssl, pkg-config, protobuf
, cacert, testers, Security, garage, nixosTests }:
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

    checkInputs = [
      cacert
    ];

    OPENSSL_NO_VENDOR = true;

    # See https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v0.7.2/default.nix#L84-L98
    # on version changes for checking if changes are required here
    buildFeatures = [
      "kubernetes-discovery"
    ] ++
    (lib.optionals (lib.versionAtLeast version "0.8") [
      "bundled-libs"
      "sled"
      "metrics"
      "k2v"
      "telemetry-otlp"
      "lmdb"
      "sqlite"
      "consul-discovery"
    ]);

    # To make integration tests pass, we include the optional k2v feature here,
    # but in buildFeatures only for version 0.8+, where it's enabled by default.
    # See: https://garagehq.deuxfleurs.fr/documentation/reference-manual/k2v/
    checkFeatures = [
      "k2v"
      "kubernetes-discovery"
    ] ++
    (lib.optionals (lib.versionAtLeast version "0.8") [
      "bundled-libs"
      "sled"
      "lmdb"
      "sqlite"
    ]);

    # Workaround until upstream fixes integration test race condition
    # https://git.deuxfleurs.fr/Deuxfleurs/garage/issues/528
    dontUseCargoParallelTests = true;

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

    garage_0_8_1 = generic {
      version = "0.8.1";
      sha256 = "sha256-lpNp/jw4YaczG3NM3pVWR0cZ8u/KBQCWvvfAswO4+Do=";
      cargoSha256 = "sha256-TXHSAnttXfxoFLOP+vsd86O8sVoyrSkadij26cF4aXI=";
    };

    garage_0_8 = garage_0_8_1;

    garage = garage_0_8;
  }
