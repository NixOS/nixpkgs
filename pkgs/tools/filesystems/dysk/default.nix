{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    rev = "v${version}";
    hash = "sha256-5KUTb2mSYQdkT3K5BrBCQqq45q0MzFYG1UmE+5eBnuc=";
  };

  cargoHash = "sha256-YmA1Qx3oKHXlXs3FWoLMRAnFdIQaFdLJaNwj/FxIS5Q=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage $releaseDir/build/*/out/dysk.1
    installShellCompletion $releaseDir/build/*/out/{dysk.bash,dysk.fish,_dysk}
  '';

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/dysk";
    changelog = "https://github.com/Canop/dysk/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda koral ];
  };
}
