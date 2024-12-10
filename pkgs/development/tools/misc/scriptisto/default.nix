{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "scriptisto";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "igor-petruk";
    repo = "scriptisto";
    rev = "v${version}";
    hash = "sha256-WQSgN1iX26tPPaJXLtU5Eo8kFahT6g+gZKJEDT6zj1E=";
  };

  cargoHash = "sha256-trDf6N7PMjxlum8Rx2TxGePM6UPzMlTU6ATyGzmFoNc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage man/*
  '';

  meta = with lib; {
    description = "A language-agnostic \"shebang interpreter\" that enables you to write scripts in compiled languages";
    mainProgram = "scriptisto";
    homepage = "https://github.com/igor-petruk/scriptisto";
    changelog = "https://github.com/igor-petruk/scriptisto/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
