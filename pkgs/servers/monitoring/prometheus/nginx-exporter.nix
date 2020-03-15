{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "nginx_exporter";
  version = "0.6.0";

  goPackagePath = "github.com/nginxinc/nginx-prometheus-exporter";

  buildFlagsArray = [
    "-ldflags=" "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    sha256 = "1rwafmm9x0sxj4z7x4axhrjgdy15z70a1y00hw6smq30fcpkazhq";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    homepage = "https://github.com/nginxinc/nginx-prometheus-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz willibutz globin ];
    platforms = platforms.unix;
  };
}
