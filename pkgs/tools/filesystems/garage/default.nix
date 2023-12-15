{ lib
, stdenv
, rustPlatform
, fetchFromGitea
, fetchpatch
, openssl
, pkg-config
, protobuf
, cacert
, Security
, garage
, nixosTests
}:
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

    # See https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v0.8.2/nix/compile.nix#L192-L198
    # on version changes for checking if changes are required here
    buildFeatures = [
      "kubernetes-discovery"
      "bundled-libs"
      "sled"
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
    checkFeatures = [
      "k2v"
      "kubernetes-discovery"
      "bundled-libs"
      "sled"
      "lmdb"
      "sqlite"
    ];

    passthru.tests = nixosTests.garage;

    meta = {
      description = "S3-compatible object store for small self-hosted geo-distributed deployments";
      homepage = "https://garagehq.deuxfleurs.fr";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ nickcao _0x4A6F teutat3s raitobezarius ];
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

  garage_0_8_4 = generic {
    version = "0.8.4";
    sha256 = "sha256-YgMw41ofM59h7OnHK1H8+Se5mZEdYypPIdkqbyX9qfs=";
    cargoSha256 = "sha256-dEtksOVqy5wAPoqCuXJj3c4TB6UbR8PTaB70fbL6iR8=";
  };

  garage_0_8 = garage_0_8_4;

  garage_0_9_0 = (generic {
    version = "0.9.0";
    sha256 = "sha256-Bw7ohMAfnbkhl43k8KxYu2OJd5689PqDS0vAcgU09W8=";
    cargoSha256 = "sha256-JqCt/8p24suQMRzEyTE2OkbzZCGUDLuGq32kCq3eZ7o=";
  }).overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches or [ ] ++ [
      (fetchpatch {
        url = "https://git.deuxfleurs.fr/Deuxfleurs/garage/commit/c7f5dcd953ff1fdfa002a8bccfb43eafcc6fddd4.patch";
        sha256 = "sha256-q7E6gtPjnj5O/K837LMP6LPEFcgdkifxRFrYzBuqkk0=";
      })
    ];
  });

  garage_0_9 = garage_0_9_0;

  garage = garage_0_9;
}
