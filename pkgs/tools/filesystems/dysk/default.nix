{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    rev = "v${version}";
    hash = "sha256-h/vdc7ltlXJQi1f013+fNyYB6fc0hTUcx4LN6UySIGM=";
  };

  cargoHash = "sha256-LC7A+fu4SqfsxT3K9gYJPx8G9h+7kXq0Nq70iSlfygE=";

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
