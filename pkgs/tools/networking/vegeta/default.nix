{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "vegeta";
  version = "12.8.4";

  src = fetchFromGitHub {
    owner  = "tsenart";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0sw10k4g370c544dgw2c1sqdnxryld8lf6c1wnyknrm3zsfzn1hl";
  };

  goPackagePath = "github.com/tsenart/${pname}";

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Versatile HTTP load testing tool";
    license = licenses.mit;
    homepage = "https://github.com/tsenart/vegeta/";
    maintainers = [ maintainers.mmahut ];
  };
}

