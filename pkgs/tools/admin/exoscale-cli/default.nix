{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "exoscale-cli";
<<<<<<< HEAD
  version = "1.72.2";
=======
  version = "1.68.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "exoscale";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-EUHjkhorfqRPStwThO5rdBVtl+NltEv18Bno4zu+5Us=";
=======
    sha256 = "sha256-GDnHwHKbe+8Qv2zxcKqHQ9s9dS9jvE6qNXe35FeQEKQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" ];

  # we need to rename the resulting binary but can't use buildFlags with -o here
  # because these are passed to "go install" which does not recognize -o
  postBuild = ''
    mv $GOPATH/bin/cli $GOPATH/bin/exo

    mkdir -p manpage
    $GOPATH/bin/docs --man-page
    rm $GOPATH/bin/docs

    $GOPATH/bin/completion bash
    $GOPATH/bin/completion zsh
    rm $GOPATH/bin/completion
  '';

  postInstall = ''
    installManPage manpage/*
    installShellCompletion --cmd exo --bash bash_completion --zsh zsh_completion
  '';

  meta = {
    description = "Command-line tool for everything at Exoscale: compute, storage, dns";
    homepage = "https://github.com/exoscale/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ viraptor ];
    mainProgram = "exo";
  };
}
