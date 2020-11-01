{ stdenvNoCC, lib, fetchFromGitHub, installShellFiles }:
stdenvNoCC.mkDerivation rec {
  pname = "zplugin";
  version = "2.3";
  src = fetchFromGitHub {
    owner = "zdharma";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qqv5p19s8jb06d6h55dm4acji9x2rpxb2ni3h7fb0q43iz6y85w";
  };
  # adapted from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=zsh-zplugin-git
  dontBuild = true;
  nativeBuildInputs = [ installShellFiles ];
  installPhase = ''
    outdir="$out/share/$pname"

    cd "$src"

    # Zplugin's source files
    install -dm0755 "$outdir"
    install -m0644 zplugin{,-side,-install,-autoload}.zsh "$outdir"
    install -m0755 git-process-output.zsh "$outdir"

    # Zplugin autocompletion
    installShellCompletion --zsh _zplugin

    #TODO:Zplugin-module files
    # find zmodules/ -type d -exec install -dm 755 "{}" "$outdir/{}" \;
    # find zmodules/ -type f -exec install -m 744 "{}" "$outdir/{}" \;

  '';
  #TODO:doc output

  meta = with lib; {
    homepage = "https://github.com/zdharma/zplugin";
    description = "Flexible zsh plugin manager";
    license = licenses.mit;
    maintainers = with maintainers; [ pasqui23 ];
  };
}
