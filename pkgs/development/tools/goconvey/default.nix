{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goconvey";
  version = "1.7.2";

  excludedPackages = "web/server/watch/integration_testing";

  src = fetchFromGitHub {
    owner = "smartystreets";
    repo = "goconvey";
    rev = "v${version}";
    sha256 = "sha256-YT9M9VaLIGUo6pdkaLWLtomcjrDqdnOqwl+C9UwDmT8=";
  };

  vendorSha256 = "sha256-sHyK/4YdNCLCDjxjMKygWAVRnHZ1peYjYRYyEcqoe+E=";

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
