{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dovecot_exporter-${version}";
  version = "0.1.3";

  goPackagePath = "github.com/kumina/dovecot_exporter";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "dovecot_exporter";
    rev = version;
    sha256 = "1lnxnnm45fhcyv40arcvpiiibwdnxdwhkf8sbjpifx1wspvphcj9";
  };

  goDeps = ./dovecot-exporter-deps.nix;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Prometheus metrics exporter for Dovecot";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
