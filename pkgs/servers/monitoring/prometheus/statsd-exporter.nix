{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "statsd_exporter";
  version = "0.20.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "statsd_exporter";
    sha256 = "1k98dmjn2mfwg36khpbxg7yk6rn4sk4v264i4rmqs4v8gss2h3kn";
  };

  vendorSha256 = "1fihbchl5g5z9xrca68kaq26l674chcby634k8iz5h31dai8hpyh";

  meta = with lib; {
    description = "Receives StatsD-style metrics and exports them to Prometheus";
    homepage = "https://github.com/prometheus/statsd_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ivan ];
    platforms = platforms.unix;
  };
}
