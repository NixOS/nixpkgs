{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "nginx_exporter";
  version = "0.4.2";

  goPackagePath = "github.com/nginxinc/nginx-prometheus-exporter";

  buildFlagsArray = [
    "-ldflags=" "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    sha256 = "023nl83w0fic7sj0yxxgj7jchyafqnmv6dq35amzz37ikx92mdcj";
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
