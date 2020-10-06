{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tegola";
  version = "0.12.1";

  goPackagePath = "github.com/go-spatial/tegola";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x8wv9xx0dafn55y0i7x43plg1blnslzj0l5047laipw7gnmfwad";
  };

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/cmd/tegola/cmd.Version=${version}" ];

  excludedPackages = [ "example" ];

  meta = with stdenv.lib; {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    maintainers = with maintainers; [ ingenieroariel ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
