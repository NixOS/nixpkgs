{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "chezmoi";
  version = "2.33.6";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    hash = "sha256-tBEhhYfwbipOmGl9lkzhOdXRf3CPNhaIYi4wppAW4Ps=";
  };

  vendorHash = "sha256-NDqwA6JHpq8ItT7ctv3KKkUwDZNgAjfgigqX9mGEYVY=";

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
