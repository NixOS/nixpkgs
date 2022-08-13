{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "7.2.4";

  src = fetchFromGitHub {
    owner = "peterbourgon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dg2JPVZJSjbBirvKvfQHGi06Fah48RHk5vbHgn5Q59M=";
  };

  vendorSha256 = "sha256-wsOgZTeErUQkt+yJ7P0Oi8Ks7WBj/e457lZNs+ZwJgY=";

  meta = with lib; {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/peterbourgon/fastly-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
