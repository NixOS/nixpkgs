{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazygit";
  version = "0.20.9";

  goPackagePath = "github.com/jesseduffield/lazygit";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jmg2z8yza8cy6xcyam4pvk0sp6zvw6b8vbn3b3h0pklfa7wz9pg";
  };

  meta = with stdenv.lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz equirosa filalex77 ];
  };
}
