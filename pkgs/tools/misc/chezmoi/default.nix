{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "chezmoi";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "1ww8xcf57csazj3q2569irxg5il29jrx43mq5cif8dvn8xjm00nn";
  };

  modSha256 = "1zmvav19nyqv6yp71mk3lx6szc5vwyf81m8kvcjj9rlzlygmcl8g";

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

  meta = with stdenv.lib; {
    homepage = "https://www.chezmoi.io/";
    description = "Manage your dotfiles across multiple machines, securely";
    license = licenses.mit;
    maintainers = with maintainers; [ jhillyerd ];
    platforms = platforms.all;
  };
}
