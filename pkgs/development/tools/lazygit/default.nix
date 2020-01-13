{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "lazygit";
  version = "0.13";

  goPackagePath = "github.com/jesseduffield/lazygit";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    sha256 = "1illn4aqg4gyjnrh505f1s7blk826nqx6mc9i06i0fc1lw5jsxx1";
  };

  meta = with stdenv.lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz equirosa filalex77 ];
  };
}
