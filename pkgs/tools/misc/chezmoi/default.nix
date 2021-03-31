{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "chezmoi";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "sha256-mq9kwkEeh+kVhiVy/h44oP3Rj819gGQDiMifSb7ryeY=";
  };

  vendorSha256 = "sha256-YU+t8GVsLYWONezUIB4NUrVxtYOmf/2b5v4v3VSYtBU=";

  doCheck = false;

  buildFlagsArray = [
    "-ldflags=-s -w -X main.version=${version} -X main.builtBy=nixpkgs"
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
