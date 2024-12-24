{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  bzip2,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "pactorio";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3+irejeDltf7x+gyJxWBgvPgpQx5uU3DewU23Z4Nr/A=";
  };

  cargoHash = "sha256-sAFsG+EPSmvPDFR9R0fZ5f+y/PXVpTJlMzL61vwf4SY=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ bzip2 ] ++ lib.optional stdenv.hostPlatform.isDarwin Security;

  postInstall = ''
    installManPage artifacts/pactorio.1
    installShellCompletion artifacts/pactorio.{bash,fish} --zsh artifacts/_pactorio
  '';

  GEN_ARTIFACTS = "artifacts";

  meta = with lib; {
    description = "Mod packager for factorio";
    mainProgram = "pactorio";
    homepage = "https://github.com/figsoda/pactorio";
    changelog = "https://github.com/figsoda/pactorio/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
