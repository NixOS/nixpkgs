{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sagoin";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zXYjR9ZFNX2guUSeMN/G77oBIlW3AowFWA4gwID2jQs=";
  };

  cargoHash = "sha256-NMv48gv3RUIjBRD2XuOhmS32d+MjZ/tP/ZhpRuyulgE=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  postInstall = ''
    installManPage artifacts/sagoin.1
    installShellCompletion artifacts/sagoin.{bash,fish} --zsh artifacts/_sagoin
  '';

  GEN_ARTIFACTS = "artifacts";

  meta = with lib; {
    description = "Command-line submission tool for the UMD CS Submit Server";
    homepage = "https://github.com/figsoda/sagoin";
    changelog = "https://github.com/figsoda/sagoin/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "sagoin";
  };
}
