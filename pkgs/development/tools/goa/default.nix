{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper }:

buildGoPackage rec {
  name = "goa-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/goadesign/goa";
  subPackages = [ "goagen" ];

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "13401jf907z3qh11h9clb3z0i0fshwkmhx11fq9z6vx01x8x2in1";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://goa.design;
    description = "A framework for building microservices in Go using a unique design-first approach";
    license = licenses.mit;
    maintainers = [ maintainers.rushmorem ];
  };
}
