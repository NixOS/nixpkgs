{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "page";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "I60R";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iK8XRPT/0PG3szIRkHvUIdgJC1XsuBbDKk25RvwSViQ=";
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    completions_dir=$(find "target" -name "shell_completions" -type d -printf "%T+\t%p\n" | sort | awk 'NR==1{print $2}')
    installShellCompletion --bash $completions_dir/page.bash
    installShellCompletion --fish $completions_dir/page.fish
    installShellCompletion --zsh $completions_dir/_page
  '';

  cargoSha256 = "sha256-OZvsZijrIeVxqf58P16Woanf0JsJIENX72n28wMtq14=";

  meta = with lib; {
    description = "Use neovim as pager";
    homepage = "https://github.com/I60R/page";
    license = licenses.mit;
    maintainers = [ maintainers.s1341 ];
  };
}
