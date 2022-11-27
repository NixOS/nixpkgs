{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "page";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "I60R";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-w/6uCzBRXsmq7Khe+8ysfgBoxnWBLyRMyb43sCxNYMA=";
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    completions_dir=$(find "target" -name "shell_completions" -type d -printf "%T+\t%p\n" | sort | awk 'NR==1{print $2}')
    installShellCompletion --bash $completions_dir/page.bash
    installShellCompletion --fish $completions_dir/page.fish
    installShellCompletion --zsh $completions_dir/_page
  '';

  cargoSha256 = "sha256-xHGlJxUpmqR+WoKURpRAJAhmmKXIO0SWg9VLFiinKfo=";

  meta = with lib; {
    description = "Use neovim as pager";
    homepage = "https://github.com/I60R/page";
    license = licenses.mit;
    maintainers = [ maintainers.s1341 ];
  };
}
