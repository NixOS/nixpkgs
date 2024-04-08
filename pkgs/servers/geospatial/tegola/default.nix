{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tegola";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = "tegola";
    rev = "v${version}";
    sha256 = "sha256-Jlpw3JaU5+DO7Z5qruEMoLRf95cPGd9Z+MeDGSgbMjc=";
  };

  vendorHash = null;

  subPackages = [ "cmd/tegola" ];

  ldflags = [ "-s" "-w" "-X github.com/go-spatial/tegola/internal/build.Version=${version}" ];

  meta = with lib; {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    mainProgram = "tegola";
    maintainers = with maintainers; [ ingenieroariel ];
    license = licenses.mit;
  };
}
