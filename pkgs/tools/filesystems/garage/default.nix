{ lib, rustPlatform, fetchFromGitea, testVersion, garage }:
rustPlatform.buildRustPackage rec {
  pname = "garage";
  version = "0.6.1";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "garage";
    rev = "v${version}";
    sha256 = "sha256-BEFxPU4yPtctN7H+EcxJpXnf4tyqBseskls0ZA9748k=";
  };

  cargoSha256 = "sha256-/mOH7VOfIHEydnJUUSts44aGb8tS1/Faxiu4pQDeobY=";

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
