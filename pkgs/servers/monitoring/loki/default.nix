{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  version = "0.1.0";
  name = "grafana-loki-${version}";
  goPackagePath = "github.com/grafana/loki";

  doCheck = true;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "loki";
    sha256 = "18iysr8p84vd1sdjdnpc9cydd5rpw0azdjzpz8yjqhscqw9gk4w2";
  };

  meta = with stdenv.lib; {
    description = "Like Prometheus, but for logs.";
    license = licenses.asl20;
    homepage = https://grafana.com/loki;
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.linux;
  };
}
