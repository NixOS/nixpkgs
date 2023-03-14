{ lib
, rustPlatform
, fetchFromGitHub
, help2man
, installShellFiles
, pkg-config
, bzip2
, xz
, zlib
, zstd
}:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = pname;
    rev = version;
    sha256 = "sha256-WzdKr0i31qNRm1EpMZ/W4fOfKKItmvz6BYFbJWcfoHo=";
  };

  cargoSha256 = "sha256-UhKcWpNuRNyA+uUw5kx84Y2F1Swr05m7JUM1+9lXYPM=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ bzip2 xz zlib zstd ];

  buildFeatures = [ "zstd/pkg-config" ];

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/ouch.{bash,fish} --zsh artifacts/_ouch
  '';

  OUCH_ARTIFACTS_FOLDER = "artifacts";

  meta = with lib; {
    description = "A command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    changelog = "https://github.com/ouch-org/ouch/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda psibi ];
  };
}
