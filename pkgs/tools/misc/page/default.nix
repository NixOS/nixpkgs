{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "page";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "I60R";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pk3iclmwbkg4nvsgarq4qjpzapjhsl7b7z6zw6havp1zmx9h806";
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    completions_dir=$(find "target" -name "shell_completions" -type d -printf "%T+\t%p\n" | sort | awk 'NR==1{print $2}')

    installShellCompletion --bash $completions_dir/page.bash
    installShellCompletion --fish $completions_dir/page.fish
    installShellCompletion --zsh $completions_dir/_page
  '';

  cargoSha256 = "19ff5h8z34z15wdnd3mj8bwlqcixwbimys77gfjmzb3w1g9ivlks";

  meta = with lib; {
    description = "Use neovim as pager";
    homepage = "https://github.com/I60R/page";
    license = licenses.mit;
    maintainers = [ maintainers.s1341 ];
  };
}
