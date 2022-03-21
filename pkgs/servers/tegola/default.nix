{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tegola";
  version = "0.14.0";

  goPackagePath = "github.com/go-spatial/tegola";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/1UhgcMLCB1/HtDX6HvVXybn3jOCRLuz2AF+M52Aye0=";
  };

  ldflags = [ "-s" "-w" "-X ${goPackagePath}/cmd/tegola/cmd.Version=${version}" ];

  excludedPackages = [ "example" ];

  meta = with lib; {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    maintainers = with maintainers; [ ingenieroariel ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
