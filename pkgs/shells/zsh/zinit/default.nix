{ stdenvNoCC, lib, fetchFromGitHub, installShellFiles }:

stdenvNoCC.mkDerivation rec {
  pname = "zinit";
  version = "3.7";
  src = fetchFromGitHub {
    owner = "zdharma-continuum";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B+cTGz+U8MR22l6xXdRAAjDr+ulCk+CJ9GllFMK0axE=";
  };
  # adapted from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=zsh-zplugin-git
  dontBuild = true;
  strictDeps = true;
  nativeBuildInputs = [ installShellFiles ];
  installPhase = ''
    outdir="$out/share/$pname"

    cd "$src"

    # Zplugin's source files
    install -dm0755 "$outdir"
    # Installing also backward compatibility layer
    install -m0644 z{plugin,init}{,-side,-install,-autoload}.zsh "$outdir"
    install -m0755 git-process-output.zsh "$outdir"

    # Zplugin autocompletion
    installShellCompletion --zsh _zinit

    #TODO:Zplugin-module files
    # find zmodules/ -type d -exec install -dm 755 "{}" "$outdir/{}" \;
    # find zmodules/ -type f -exec install -m 744 "{}" "$outdir/{}" \;

  '';
  #TODO:doc output

  meta = with lib; {
    homepage = "https://github.com/zdharma-continuum/zinit";
    description = "Flexible zsh plugin manager";
    license = licenses.mit;
    maintainers = with maintainers; [ pasqui23 sei40kr ];
  };
}
