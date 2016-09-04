{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "nginx_exporter-${version}";
  version = "20160524-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "2cf16441591f6b6e58a8c0439dcaf344057aea2b";

  goPackagePath = "github.com/discordianfish/nginx_exporter";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/discordianfish/nginx_exporter";
    sha256 = "0p9j0bbr2lr734980x2p8d67lcify21glwc5k3i3j4ri4vadpxvc";
  };

  goDeps = ./nginx-exporter_deps.json;

  meta = with stdenv.lib; {
    description = "Metrics relay from nginx stats to Prometheus";
    homepage = https://github.com/discordianfish/nginx_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
