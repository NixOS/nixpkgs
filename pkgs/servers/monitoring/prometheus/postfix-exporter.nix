{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "postfix_exporter-unstable-${version}";
  version = "2017-06-01";
  rev = "a8b4bed735a03f234fcfffba85302f51025e6b1d";

  goPackagePath = "github.com/kumina/postfix_exporter";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "postfix_exporter";
    inherit rev;
    sha256 = "0rxvjpyjcvr1y8k8skq5f1bnl0mpgvaa04dn8c44v7afqnv78riy";
  };

  goDeps = ./postfix-exporter-deps.nix;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for Postfix";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
