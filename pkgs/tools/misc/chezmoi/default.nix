{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "chezmoi";
  version = "2.33.0";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    hash = "sha256-6oxpC7o9PyfP/pfPOzhPXIxvNCO6/nnIJG+4m1iYA9Y=";
  };

  vendorHash = "sha256-a7V50zf7XZy/CTwdkud0whrFqx6LwpOIHdUWbiT7MRw=";

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
