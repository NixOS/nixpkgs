{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "peterbourgon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KL+UfYuHtfQ9sKad7Q1KqIK4CFzDsIWvgG1YO1ZbUQc=";
  };

  vendorSha256 = "sha256-yE7yvnyDfrrFdBmBBYe2gBU7b4gOWl5kfqkoblE51EQ=";

  meta = with lib; {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/peterbourgon/fastly-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
