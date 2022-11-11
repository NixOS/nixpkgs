{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "7.2.5";

  src = fetchFromGitHub {
    owner = "peterbourgon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W/P4jUBNDR3t7FESNyUUnNWfGR0PI/dG03EVKYt8S2Y=";
  };

  vendorSha256 = "sha256-exoDUxcOXVn7wUqfLLtJpklPYFHjLodEYa3lF+qFD+A=";

  meta = with lib; {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/peterbourgon/fastly-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
