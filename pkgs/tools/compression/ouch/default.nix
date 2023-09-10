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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = "ouch";
    rev = version;
    hash = "sha256-XJOv7JFUJulEkGCMLxGi9nldHaPM/CUzyENIC2TdtoE=";
  };

  cargoHash = "sha256-TfAAU46rH6Jq0MuLRjbaVMRjzoSLYNAWBnUcT8DyIVg=";

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
  };
}
