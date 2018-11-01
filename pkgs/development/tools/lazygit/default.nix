{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lazygit-${version}";
  version = "0.4";

  goPackagePath = "github.com/jesseduffield/lazygit";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazygit";
    rev = "v${version}";
    sha256 = "0piljnwv778z7zc1pglkidiys1a3yv4d7z9wsrcj1nszlcn3ifyz";
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
