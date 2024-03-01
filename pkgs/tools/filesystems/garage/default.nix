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

    postPatch = ''
      # Starting in 0.9.x series, Garage is using mold in local development
      # and this leaks in this packaging, we remove it to use the default linker.
      rm .cargo/config.toml || true
    '';

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

  garage_0_8_6 = generic {
    version = "0.8.6";
    sha256 = "sha256-N0AOcwpuBHwTZtHcz6a2d9GOimHevhohEOzVkIt0RDE=";
    cargoSha256 = "sha256-e72FQKL77CZOi/pa+hE7PCyc1+HSJgEsKGgWlfVw51k=";
    broken = stdenv.isDarwin;
  };

  garage_0_8 = garage_0_8_6;

  garage_0_9_2 = generic {
    version = "0.9.2";
    sha256 = "sha256-6a400/wOZunVH+LAByd6BEA0gs56Rxyh+gvM4hUO4Y8=";
    cargoSha256 = "sha256-1p6bB2gMOCHDdILEwgoJ1EqvgGhLPcThNkwaz6NMZhQ=";
    broken = stdenv.isDarwin;
  };

  garage_0_9 = garage_0_9_2;

  garage = garage_0_9;
}
