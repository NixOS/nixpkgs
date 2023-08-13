{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tegola";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = "tegola";
    rev = "v${version}";
    sha256 = "sha256-FYKsAkOVqhgTaps0eTI/SLCEI1BRTKKpRtwKo2m7srQ=";
  };

  vendorHash = null;

  subPackages = [ "cmd/tegola" ];

  ldflags = [ "-s" "-w" "-X github.com/go-spatial/tegola/internal/build.Version=${version}" ];

  meta = with lib; {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    maintainers = with maintainers; [ ingenieroariel ];
    license = licenses.mit;
  };
}
