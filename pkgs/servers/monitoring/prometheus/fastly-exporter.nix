{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "peterbourgon";
    repo = pname;
    rev = "v${version}";
    sha256 = "0my0pcxix5rk73m5ciz513nwmjcm7vjs6r8wg3vddm0xixv7zq94";
  };

  vendorSha256 = "1w9asky8h8l5gc0c6cv89m38qw50hyhma8qbsw3zirplhk9mb3r2";

  meta = with lib; {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/peterbourgon/fastly-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
