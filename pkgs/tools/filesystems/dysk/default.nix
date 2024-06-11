{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    rev = "v${version}";
    hash = "sha256-EXP9uI98NXP1VRlhEaMTkJsAYVT9DpMFwquAVMoyjxU=";
  };

  cargoHash = "sha256-N51M9uEMfcoNyR8r76bd0PW2jSQTpU/0V+cEl82gFqk=";

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
    mainProgram = "dysk";
  };
}
