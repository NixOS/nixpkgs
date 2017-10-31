{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "nginx_exporter-${version}";
  version = "20161107-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "2d7dfd13458c0d82671c03dc54f3aa0110a49a05";

  goPackagePath = "github.com/discordianfish/nginx_exporter";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/discordianfish/nginx_exporter";
    sha256 = "17mjbf8v4h7ja87y02ggmyzl3g8ms8s37mcpcq1niijgli37h75d";
  };

  goDeps = ./nginx-exporter_deps.nix;

  meta = with stdenv.lib; {
    description = "Metrics relay from nginx stats to Prometheus";
    homepage = https://github.com/discordianfish/nginx_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
