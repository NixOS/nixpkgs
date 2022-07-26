{ lib, buildGoModule, fetchFromGitHub, testers, gojq }:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.8";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WcPvsThYgXwYXwXyylOqopTZOfsXmDU4wbhEdS3neA8=";
  };

  vendorSha256 = "sha256-fFW+gWdGMxDApcyR6dy0491WvQcVMAJ5dgMQqgNmOkw=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = gojq;
  };

  meta = with lib; {
    description = "Pure Go implementation of jq";
    homepage = "https://github.com/itchyny/gojq";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
