{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tegola";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = "tegola";
    rev = "v${version}";
    sha256 = "sha256-W1UTh8OZpWaCLwMPQopGjSqXNgO9FoIEIJIG9yOwTtY=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/tegola" ];

  ldflags = [ "-s" "-w" "-X github.com/go-spatial/tegola/internal/build.Version=${version}" ];

  meta = with lib; {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    maintainers = with maintainers; [ ingenieroariel ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
