{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "chezmoi";
  version = "1.7.9";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "1qvrzksqr06lslryh7qzs56bs11xfyah5153x3aab2f5kgk1i8md";
  };

  modSha256 = "0rzwslpikadhqw8rcbg4hbasfcgjcc850ccfnprdxva4g1bb5rqc";

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
