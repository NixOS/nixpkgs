{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tegola";
  version = "0.13.0";

  goPackagePath = "github.com/go-spatial/tegola";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NA2KwyhLLIusf6a6v+OcmHz91kPcIhvG9PRmRk8h+fQ=";
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
