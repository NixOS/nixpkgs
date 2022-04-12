{ lib, buildGoModule, fetchFromGitHub, testVersion, gojq }:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.7";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aQZLuwMFnggtwHZaE6KGBKJSbtmAz+Cs1RqLgvIsO24=";
  };

  vendorSha256 = "sha256-b7TQywIOxzFnUNwgxGFR3W++QGHYUROBG7P/lTRmhGc=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testVersion {
    package = gojq;
  };

  meta = with lib; {
    description = "Pure Go implementation of jq";
    homepage = "https://github.com/itchyny/gojq";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
