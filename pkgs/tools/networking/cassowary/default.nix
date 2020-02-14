{ lib, buildGoModule, fetchFromGitHub, writeText, runtimeShell, ncurses, }:

buildGoModule rec {
  pname = "cassowary";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rogerwelin";
    repo = pname;
    rev = "33b7e81a5d147980f4ddc689818df2b071f6ab4e";
    sha256 = "01cdmh2v9rz8rna08hdsddllck6zp9wcrhxdy6hs77zfsbzyfflx";
  };

  modSha256 = "1iylnnmj5slji89pkb3shp4xqar1zbpl7bzwddbzpp8y52fmsv1c";

  meta = with lib; {
    homepage = "https://github.com/rogerwelin/cassowary";
    description = "Modern cross-platform HTTP load-testing tool written in Go ";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves ];
    platforms = platforms.unix;
  };
}
