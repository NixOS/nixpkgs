{ lib, stdenv, rustPlatform, fetchFromGitea, openssl, pkg-config, protobuf
, testers, Security, garage }:

rustPlatform.buildRustPackage rec {
  pname = "garage";
  version = "0.7.3";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "garage";
    rev = "v${version}";
    sha256 = "sha256-WDhe2L+NalMoIy2rhfmv8KCNDMkcqBC9ezEKKocihJg=";
  };

  cargoSha256 = "sha256-5m4c8/upBYN8nuysDhGKEnNVJjEGC+yLrraicrAQOfI=";

  nativeBuildInputs = [ protobuf pkg-config ];

  buildInputs = [
    openssl
  ] ++ lib.optional stdenv.isDarwin Security;

  OPENSSL_NO_VENDOR = true;

  # See https://git.deuxfleurs.fr/Deuxfleurs/garage/src/tag/v0.7.2/default.nix#L84-L98
  # on version changes for checking if changes are required here
  buildFeatures = [
    "kubernetes-discovery"
  ];

  # To make integration tests pass, we include the optional k2v feature here,
  # but not in buildFeatures. See:
  # https://garagehq.deuxfleurs.fr/documentation/reference-manual/k2v/
  checkFeatures = [
    "k2v"
    "kubernetes-discovery"
  ];

  passthru = {
    tests.version = testers.testVersion { package = garage; };
  };

  meta = {
    description = "S3-compatible object store for small self-hosted geo-distributed deployments";
    homepage = "https://garagehq.deuxfleurs.fr";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ nickcao _0x4A6F teutat3s ];
  };
}
