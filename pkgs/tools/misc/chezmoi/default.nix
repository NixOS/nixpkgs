{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "chezmoi";
  version = "1.7.10";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "1miki6p611s0m3s0q5qsc9cks0akm59ks3x1gzi9wvhzf6k9h0dn";
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
