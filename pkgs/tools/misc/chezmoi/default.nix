{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "chezmoi";
  version = "2.21.1";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "sha256-WBshiEohUO58LSRpbwunXfSRvnYtnB8g+1zUZTZtUOg=";
  };

  vendorSha256 = "sha256-KcUe3Wbco+s4Zt3TS6C60AYiCuTAW5qdz+x68UBPALY=";

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
    license = licenses.mit;
    maintainers = with maintainers; [ jhillyerd ];
  };
}
