{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sagoin";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CSkij/3WCeEq26Uhlrgdf503hGf0OwSUQNmx5mspD08=";
  };

  cargoSha256 = "sha256-Zos3ox6VQv9t1KoblAJhVblTOQOn9rJyvaXK48Y/K1c=";

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
    description = "A command-line submission tool for the UMD CS Submit Server";
    homepage = "https://github.com/figsoda/sagoin";
    changelog = "https://github.com/figsoda/sagoin/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
