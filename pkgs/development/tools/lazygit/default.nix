{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazygit";
  version = "0.18";

  goPackagePath = "github.com/jesseduffield/lazygit";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zc6y386w111ygyng5s74zg49iajzs77dbrcdy33igj0hbnkwq2x";
  };

  meta = with stdenv.lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz equirosa filalex77 ];
  };
}
