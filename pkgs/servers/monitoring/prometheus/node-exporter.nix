{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "node_exporter-${version}";
  version = "0.15.0+zfs-fix";
  rev = "fix/zfs-uint64-stats";

  goPackagePath = "github.com/prometheus/node_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "mayflower";
    repo = "node_exporter";
    sha256 = "00gwr3zlbzj2gbpz59b1748p7xkzpv0rrc5afv2gqncc9pl2xgbl";
  };

  preFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -delete_rpath $out/lib $bin/bin/node_exporter
  '';

  # FIXME: megacli test fails
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = https://github.com/prometheus/node_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz ];
    platforms = platforms.unix;
  };
}
