{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dovecot_exporter-unstable-${version}";
  version = "2018-01-18";
  rev = "4e831356533e2321031df73ebd25dd55dbd8d385";

  goPackagePath = "github.com/kumina/dovecot_exporter";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "dovecot_exporter";
    inherit rev;
    sha256 = "0iky1i7m5mlknkhlpsxpjgigssg5m02nx5y7i4biddkqilfic74n";
  };

  goDeps = ./dovecot-exporter-deps.nix;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Prometheus metrics exporter for Dovecot";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
