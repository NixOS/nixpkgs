{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "node_exporter";
  version = "0.18.1";
  rev = "v${version}";


  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "node_exporter";
    sha256 = "0s3sp1gj86p7npxl38hkgs6ymd3wjjmc5hydyg1b5wh0x3yvpx07";
  };

  # FIXME: tests fail due to read-only nix store
  doCheck = false;

  buildFlagsArray = ''
    -ldflags=
  '';

  meta = with stdenv.lib; {
    description = "Prometheus exporter for machine metrics";
    homepage = "https://github.com/prometheus/node_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin ];
    platforms = platforms.unix;
  };
}