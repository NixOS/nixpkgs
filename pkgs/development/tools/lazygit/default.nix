{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazygit";
  version = "0.8";

  goPackagePath = "github.com/jesseduffield/lazygit";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zynw5gr96a59x1qshzhhvld883ndf1plnw6l9dbhmff0wcfv6l1";
  };

  meta = with stdenv.lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
