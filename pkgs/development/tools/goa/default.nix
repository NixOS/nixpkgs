{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "goa";
  version = "1.4.1";

  goPackagePath = "github.com/goadesign/goa";
  subPackages = [ "goagen" ];

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "0qcd4ii6arlpsivfdhcwidvnd8zbxxvf574jyxyvm1aazl8sqxj7";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A framework for building microservices in Go using a unique design-first approach";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = [ maintainers.rushmorem ];
    mainProgram = "goagen";
  };
}
