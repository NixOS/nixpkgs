{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tegola";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RSuTZHv3W2SVPAkydz5yB89Ioynp0DO0qaQKut5tokc=";
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
