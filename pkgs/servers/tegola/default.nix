{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tegola";
  version = "0.12.0";

  goPackagePath = "github.com/go-spatial/tegola";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bm791cis6bqgvhkk6n03kdxh0y9fdkhsx4rgmv7pm3zzdd7b17r";
  };

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/cmd/tegola/cmd.Version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    maintainers = with maintainers; [ ingenieroariel ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
