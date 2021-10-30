{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cayley";
  version = "0.7.5";

  goPackagePath = "github.com/cayleygraph/cayley";

  src = fetchFromGitHub {
    owner = "cayleygraph";
    repo = "cayley";
    rev = "v${version}";
    sha256 = "1zfxa9z6spi6xw028mvbc7c3g517gn82g77ywr6picl47fr2blnd";
  };

  goDeps = ./deps.nix;

  ldflags = [
    "-X=main.Version=${version}"
  ];

  meta = {
    homepage = "https://cayley.io/";
    description = "A graph database inspired by Freebase and Knowledge Graph";
    maintainers = with lib.maintainers; [ sigma ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
