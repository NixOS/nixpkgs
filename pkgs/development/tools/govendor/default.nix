{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "govendor-${version}";
  version = "1.0.9";

  goPackagePath = "github.com/kardianos/govendor";

  src = fetchFromGitHub {
    owner = "kardianos";
    repo = "govendor";
    rev = "v${version}";
    sha256 = "0g02cd25chyijg0rzab4xr627pkvk5k33mscd6r0gf1v5xvadcfq";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/kardianos/govendor";
    description = "Go vendor tool that works with the standard vendor file";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
