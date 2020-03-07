{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "chezmoi";
  version = "1.7.16";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "1fkjdpqal0yzm58l146pf5xpbhij9iq79933i9a77v2jihdbjn52";
  };

  modSha256 = "0gh314d3mspqmz2z3m05bgsp62mrhb48m4mwhfy5h62fs7aqymr8";

  buildFlagsArray = [
    "-ldflags=-s -w -X github.com/twpayne/chezmoi/cmd.VersionStr=${version}"
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
