{ lib, goPackages, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "prometheus-nginx-exporter-${version}";
  version = "git-2015-06-01";
  goPackagePath = "github.com/discordianfish/nginx_exporter";

  src = fetchFromGitHub {
    owner = "discordianfish";
    repo = "nginx_exporter";
    rev = "2cf16441591f6b6e58a8c0439dcaf344057aea2b";
    sha256 = "0p9j0bbr2lr734980x2p8d67lcify21glwc5k3i3j4ri4vadpxvc";
  };

  buildInputs = [
    goPackages.prometheus.client_golang
    goPackages.prometheus.log
  ];

  meta = with lib; {
    description = "Metrics relay from nginx stats to Prometheus";
    homepage = https://github.com/discordianfish/nginx_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
