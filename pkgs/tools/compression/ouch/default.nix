{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, bzip2
, xz
, zlib
, zstd
}:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = "ouch";
    rev = version;
    hash = "sha256-WqV04GhX7lIla5BEdHRgRZsAWBSweb1HFAC9XZYqpYo=";
  };

  cargoHash = "sha256-A3YcgHed5mp7//FMoC/02KAU7Y+7YiG50eWE9tP5mF8=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ bzip2 xz zlib zstd ];

  buildFeatures = [ "zstd/pkg-config" ];

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/ouch.{bash,fish} --zsh artifacts/_ouch
  '';

  env.OUCH_ARTIFACTS_FOLDER = "artifacts";

  meta = with lib; {
    description = "A command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    changelog = "https://github.com/ouch-org/ouch/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda psibi ];
    mainProgram = "ouch";
  };
}
