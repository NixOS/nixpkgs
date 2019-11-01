{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "chezmoi";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "06wgfnlzcs6yfrjpy6zhcg5y844zd22manbm2sfq5vyng02bg229";
  };

  modSha256 = "1y1q1lps3a8piikh8ds28yrw5r82af9pyl6vy87207z1y5v2hams";

  buildFlagsArray = [
    "-ldflags=-s -w -X github.com/twpayne/chezmoi/cmd.VersionStr=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash completions/chezmoi-completion.bash
    installShellCompletion --fish completions/chezmoi.fish
    installShellCompletion --zsh completions/chezmoi.zsh
  '';

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = https://github.com/twpayne/chezmoi;
    description = "Manage your dotfiles across multiple machines, securely";
    license = licenses.mit;
    maintainers = with maintainers; [ jhillyerd ];
    platforms = platforms.all;
  };
}
