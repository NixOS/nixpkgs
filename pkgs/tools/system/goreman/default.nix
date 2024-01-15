{ lib, buildGoModule, fetchFromGitHub, testers, goreman }:

buildGoModule rec {
  pname = "goreman";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "goreman";
    rev = "v${version}";
    sha256 = "sha256-Z6b245tC6UsTaHTTlKEFH0egb5z8HTmv/554nkileng=";
  };

  vendorHash = "sha256-Qbi2GfBrVLFbH9SMZOd1JqvD/afkrVOjU4ECkFK+dFA=";

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
