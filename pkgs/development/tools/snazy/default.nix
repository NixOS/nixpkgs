<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "snazy";
  version = "0.52.0";
=======
{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "snazy";
  version = "0.50.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ax16BO2I+LgaVilqrsVToulBRcyr0C/QUtrdn0nUfBU=";
  };

  cargoHash = "sha256-go6y/NH3vFb8xtAGVpgy0GQfMfzXfn8hI+tJnUdCFAU=";
=======
    sha256 = "sha256-wSRIJF2XPJvzmxuGbuPYPFgn9Eap3vqHT1CM/oQy8vM=";
  };

  cargoSha256 = "sha256-IGZZEyy9IGqkpsbnOzLdBSFbinZ7jhH2LWub/+gP89E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
=======
    homepage = "https://github.com/chmouel/snazy/";
    changelog = "https://github.com/chmouel/snazy/releases/tag/v${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A snazzy json log viewer";
    longDescription = ''
      Snazy is a simple tool to parse json logs and output them in a nice format
      with nice colors.
    '';
<<<<<<< HEAD
    homepage = "https://github.com/chmouel/snazy/";
    changelog = "https://github.com/chmouel/snazy/releases/tag/${src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda jk ];
  };
}
