{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "nginx_exporter";
  version = "0.5.0";

  goPackagePath = "github.com/nginxinc/nginx-prometheus-exporter";

  buildFlagsArray = [
    "-ldflags=" "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    sha256 = "1fyn2bjq80dx4jv1rakrm0vg6i657a5rs7kkg0f9mbv1alir8kkx";
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
