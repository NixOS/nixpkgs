{ lib, rustPlatform, fetchFromGitea, testVersion, garage }:
rustPlatform.buildRustPackage rec {
  pname = "garage";
  version = "0.6.0";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "garage";
    rev = "v${version}";
    sha256 = "sha256-NNjqDOkMMRyXce+Z7RQpuffCuVhA1U3qH30rSv939ks=";
  };

  cargoSha256 = "sha256-eKJxRcC43D8qVLORer34tlmsWhELTbcJbZLyf0MB618=";

  passthru = {
    tests.version = testVersion { package = garage; };
  };

  meta = {
    description = "S3-compatible object store for small self-hosted geo-distributed deployments";
    homepage = "https://garagehq.deuxfleurs.fr";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ nickcao _0x4A6F ];
  };
}
