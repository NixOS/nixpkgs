{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "chezmoi";
  version = "2.48.0";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    hash = "sha256-TclY4O5mA14cI7+qvGwt5jSHftxhGaa3ICVn8qdrKqs=";
  };

  vendorHash = "sha256-qoXfneNEAsvUgaEFHPF1bf/S8feFX+8HtwQy7nzy8Bo=";

  doCheck = false;

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.builtBy=nixpkgs"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash --name chezmoi.bash completions/chezmoi-completion.bash
    installShellCompletion --fish completions/chezmoi.fish
    installShellCompletion --zsh completions/chezmoi.zsh
  '';

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://www.chezmoi.io/";
    description = "Manage your dotfiles across multiple machines, securely";
    changelog = "https://github.com/twpayne/chezmoi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jhillyerd ];
    mainProgram = "chezmoi";
  };
}
