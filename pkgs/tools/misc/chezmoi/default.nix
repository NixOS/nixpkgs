{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "chezmoi";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "sha256-WVG4rww9Wd1H6zw5lRBErX9VwnA21dhvith9BQFYqxw=";
  };

  vendorSha256 = "sha256-khYcNP3xAXeQR9vaghkGq8x6KB1k5hLEcE7Zx8H+CfA=";

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
