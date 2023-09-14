{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "snazy";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = version;
    hash = "sha256-ax16BO2I+LgaVilqrsVToulBRcyr0C/QUtrdn0nUfBU=";
  };

  cargoHash = "sha256-go6y/NH3vFb8xtAGVpgy0GQfMfzXfn8hI+tJnUdCFAU=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
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
    description = "A snazzy json log viewer";
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
