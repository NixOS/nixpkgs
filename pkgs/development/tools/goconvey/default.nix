{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goconvey";
  version = "1.8.1";

  excludedPackages = "web/server/watch/integration_testing";

  src = fetchFromGitHub {
    owner = "smartystreets";
    repo = "goconvey";
    rev = "v${version}";
    hash = "sha256-6SrlPsOqRxNNwEYx2t1v+rEHnQ58GvJtjo87SZo/Omk=";
  };

  vendorHash = "sha256-020bxa0LErrvRKe3HirCWZDaBQFfKsWgl4mxfLtl1lg=";

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    buildFlagsArray+="-short"
  '';

  meta = {
    description = "Go testing in the browser. Integrates with `go test`. Write behavioral tests in Go";
    homepage = "https://github.com/smartystreets/goconvey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}
