{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "goa-${version}";
  version = "1.4.0";

  goPackagePath = "github.com/goadesign/goa";
  subPackages = [ "goagen" ];

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "1qx3c7dyq5wqxidfrk3ywc55fk64najj63f2jmfisfq4ixgwxdw9";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://goa.design;
    description = "A framework for building microservices in Go using a unique design-first approach";
    license = licenses.mit;
    maintainers = [ maintainers.rushmorem ];
  };
}
