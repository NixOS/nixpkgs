{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lazygit-${version}";
  version = "0.5";

  goPackagePath = "github.com/jesseduffield/lazygit";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazygit";
    rev = "v${version}";
    sha256 = "0xgda2b5p26ya15kq83502f8vh18kl05hl40k0lsfqx3m7pnidn1";
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
