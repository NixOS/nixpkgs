{ lib
, stdenvNoCC
, fetchFromGitHub
, installShellFiles
, patsh
}:

stdenvNoCC.mkDerivation rec {
  pname = "script-directory";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ianthehenry";
    repo = "sd";
    rev = "v${version}";
    hash = "sha256-X5RWCJQUqDnG2umcCk5KS6HQinTJVapBHp6szEmbc4U=";
  };

  nativeBuildInputs = [
    installShellFiles
    patsh
  ];

  installPhase = ''
    runHook preInstall

    patsh -f sd
    install -Dt "$out/bin" sd
    installShellCompletion --zsh _sd

    runHook postInstall
  '';

  meta = {
    description = "A cozy nest for your scripts";
    homepage = "https://github.com/ianthehenry/sd";
    changelog = "https://github.com/ianthehenry/sd/tree/${src.rev}#changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ janik ];
    mainProgram = "sd";
  };
}
