{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "haproxy_exporter-${version}";
  version = "0.4.0";
  rev = version;

  goPackagePath = "github.com/prometheus/haproxy_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "haproxy_exporter";
    sha256 = "0cwls1d4hmzjkwc50mjkxjb4sa4q6yq581wlc5sg9mdvl6g91zxr";
  };

  goDeps = ./haproxy-exporter_deps.json;

  meta = with stdenv.lib; {
    description = "HAProxy Exporter for the Prometheus monitoring system";
    homepage = https://github.com/prometheus/haproxy_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
