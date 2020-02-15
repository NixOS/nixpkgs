{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "chezmoi";
  version = "1.7.13";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "1xqmr7sps5s3ib4q91z7drwlglp1av37gb2jm0zw7y3ijyp2c749";
  };

  modSha256 = "07fglc3k3a5y70slly4ri3izwnyk4nwghmvkjwgc8lbw8m1zx0r8";

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
