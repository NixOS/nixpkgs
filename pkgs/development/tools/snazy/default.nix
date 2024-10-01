{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "snazy";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = version;
    hash = "sha256-iRoNmqZadwUxowcC/emqdGhOWMl5c1OJr/VVyxYg2h0=";
  };

  cargoHash = "sha256-e39lmGEPRU/vATcJKB89+B/STi1viP6r43X4Y2u/fe4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd snazy \
      --bash <($out/bin/snazy --shell-completion bash) \
      --fish <($out/bin/snazy --shell-completion fish) \
      --zsh <($out/bin/snazy --shell-completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/snazy --help
    $out/bin/snazy --version | grep "snazy ${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Snazzy json log viewer";
    mainProgram = "snazy";
    longDescription = ''
      Snazy is a simple tool to parse json logs and output them in a nice format
      with nice colors.
    '';
    homepage = "https://github.com/chmouel/snazy/";
    changelog = "https://github.com/chmouel/snazy/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda jk ];
  };
}
