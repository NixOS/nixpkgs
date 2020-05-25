{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "vegeta";
  version = "12.7.0";

  src = fetchFromGitHub {
    owner = "tsenart";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wzx9588hjzxq65fxi1zz9xpsw33qq41hpl0j2f077g4m8yxahv5";
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

