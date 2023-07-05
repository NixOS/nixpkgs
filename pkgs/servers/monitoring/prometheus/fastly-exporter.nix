{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "7.6.0";

  src = fetchFromGitHub {
    owner = "peterbourgon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-55yqt1F/jBoWHhq/Q9qOiCxg9naGrCFxGyfLseg9R/w=";
  };

  vendorHash = "sha256-lEaMhJL/sKNOXx0W+QHMG4QUUE6Pc4AqulhgyCMQQNY=";

  meta = with lib; {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/peterbourgon/fastly-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
