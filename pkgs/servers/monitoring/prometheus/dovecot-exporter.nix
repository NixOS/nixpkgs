{
  lib,
  buildGoPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildGoPackage rec {
  pname = "dovecot_exporter";
  version = "0.1.3";

  goPackagePath = "github.com/kumina/dovecot_exporter";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "dovecot_exporter";
    rev = version;
    sha256 = "1lnxnnm45fhcyv40arcvpiiibwdnxdwhkf8sbjpifx1wspvphcj9";
  };

  goDeps = ./dovecot-exporter-deps.nix;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) dovecot; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Prometheus metrics exporter for Dovecot";
    mainProgram = "dovecot_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      willibutz
      globin
    ];
  };
}
