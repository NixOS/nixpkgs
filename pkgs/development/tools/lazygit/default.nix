{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lazygit-${version}";
  version = "0.7.2";

  goPackagePath = "github.com/jesseduffield/lazygit";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazygit";
    rev = "v${version}";
    sha256 = "1b5mzmxw715cx7b0n22hvrpk0dbavzypljc7skwmh8k1nlx935jj";
  };

  postPatch = ''
    rm -rf scripts
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Simple terminal UI for git commands";
    license = licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
    platforms = stdenv.lib.platforms.unix;
  };
}
