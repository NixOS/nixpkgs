{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, bzip2
, xz
, zlib
, zstd
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = "ouch";
    rev = version;
    hash = "sha256-WO1fetu39fcLGcrbzFh+toHpnyxWuDVHtmjuH203hzQ=";
  };

  cargoHash = "sha256-OdAu7fStTJCF1JGJG9TRE1Qosy6yjKsWq01MYpbXZcg=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ bzip2 xz zlib zstd ];

  buildFeatures = [ "zstd/pkg-config" ];

  preCheck = ''
    substituteInPlace tests/ui.rs \
      --replace 'format!(r"/private{path}")' 'path.to_string()'
  '';

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
