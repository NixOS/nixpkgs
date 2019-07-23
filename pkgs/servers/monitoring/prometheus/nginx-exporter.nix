{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nginx_exporter-${version}";
  version = "0.4.1";

  goPackagePath = "github.com/nginxinc/nginx-prometheus-exporter";

  buildFlagsArray = [
    "-ldflags=" "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    sha256 = "0c5bxl9xrd4gh2w5wyrzghmbcy9k1khydzml5cm0rsyqhwsvs8m5";
  };

  meta = with stdenv.lib; {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    homepage = "https://github.com/nginxinc/nginx-prometheus-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz willibutz ];
    platforms = platforms.unix;
  };
}
