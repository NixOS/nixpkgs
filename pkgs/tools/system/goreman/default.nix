{ lib, buildGoModule, fetchFromGitHub, testers, goreman }:

buildGoModule rec {
  pname = "goreman";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "goreman";
    rev = "v${version}";
    sha256 = "sha256-BQMRkXHac2Is3VvqrBFA+/NrR3sw/gA1k3fPi3EzONQ=";
  };

  vendorSha256 = "sha256-BWfhvJ6kPz3X3TpHNvRIBgfUAQJB2f/lngRvHq91uyw=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = goreman;
    command = "goreman version";
  };

  meta = with lib; {
    description = "foreman clone written in go language";
    homepage = "https://github.com/mattn/goreman";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
