{ stdenv, lib, goPackages, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  name = "prometheus-statsd-bridge-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "9715b183150c7bed8a10affb23d33fb55c597180";
  goPackagePath = "github.com/prometheus/statsd_bridge";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "statsd_bridge";
    sha256 = "119024xb08qjwbhplpl5d94bjdfhn92w4ffn4kxr7aviri1gynfz";
  };

  buildInputs = with goPackages; [
    fsnotify
    prometheus.client_golang
  ];

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = https://github.com/prometheus/statsd_bridge;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
