{ lib, stdenv, rustPlatform, fetchFromGitea, protobuf, testers, Security, garage }:

rustPlatform.buildRustPackage rec {
  pname = "garage";
  version = "0.7.0";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "garage";
    rev = "v${version}";
    sha256 = "sha256-gs0TW431YUrdsdJ+PYrJgnLiBmDPYnUR0iVnQ/YqIfU=";
  };

  cargoSha256 = "sha256-XGSenT2q3VXNcIT1Lg1e5HTOkEdOb1o3H07ahteQM/o=";

  nativeBuildInputs = [ protobuf ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  passthru = {
    tests.version = testers.testVersion { package = garage; };
  };

  meta = {
    description = "S3-compatible object store for small self-hosted geo-distributed deployments";
    homepage = "https://garagehq.deuxfleurs.fr";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ nickcao _0x4A6F ];
  };
}
