{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "cayley-${version}";
  version = "0.6.1";

  goPackagePath = "github.com/cayleygraph/cayley";

  src = fetchFromGitHub {
    owner = "cayleygraph";
    repo = "cayley";
    rev = "v${version}";
    sha256 = "1r0kw3y32bqm7g37svzrch2qj9n45p93xmsrf7dj1cg4wwkb65ry";
  };

  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags=
      -X=main.Version=${version}
  '';
  
  meta = {
    homepage = "https://cayley.io/";
    description = "A graph database inspired by Freebase and Knowledge Graph";
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
