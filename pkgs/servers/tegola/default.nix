{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tegola";
  version = "0.11.2";

  goPackagePath = "github.com/go-spatial/tegola";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xrjs0py08q9i31rl0cxi6idncrrgqwcspqks3c5vd9i65yqc6fv";
  };

  meta = with stdenv.lib; {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    maintainers = with maintainers; [ ingenieroariel ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
