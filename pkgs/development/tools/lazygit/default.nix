{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazygit";
  version = "0.20.5";

  goPackagePath = "github.com/jesseduffield/lazygit";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    sha256 = "0968aww43gvc4wx2nyjyavclyspls7rbdlpzq6k5z7pgf4mgganw";
  };

  meta = with stdenv.lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz equirosa filalex77 ];
  };
}
