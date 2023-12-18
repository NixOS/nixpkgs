{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "simplehttp2server";
  version = "3.1.3";

  goPackagePath = "github.com/GoogleChromeLabs/simplehttp2server";

  src = fetchFromGitHub {
     owner = "GoogleChromeLabs";
     repo = "simplehttp2server";
     rev = version;
     sha256 = "113mcfvy1m91wask5039mhr0187nlw325ac32785yl4bb4igi8aw";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
     homepage = "https://github.com/GoogleChromeLabs/simplehttp2server";
     description = "HTTP/2 server for development purposes";
     license = licenses.asl20;
     maintainers = with maintainers; [ yrashk ];
     mainProgram = "simplehttp2server";
  };

}
