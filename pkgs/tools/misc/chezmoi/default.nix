{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "chezmoi";
  version = "2.34.2";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    hash = "sha256-rq+TN9j/PX2h3lzK+WhcB3KBgvcTyXyU9VApelqfIJE=";
  };

  vendorHash = "sha256-UyWrvReFUCQ091Mbk1iJE55rJkkmTyMX4yvb9ppszt8=";

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
  };
}
