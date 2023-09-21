{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goconvey";
  version = "1.8.0";

  excludedPackages = "web/server/watch/integration_testing";

  src = fetchFromGitHub {
    owner = "smartystreets";
    repo = "goconvey";
    rev = "v${version}";
    sha256 = "sha256-JgforTGu5aiQHltZrAfy16Bsu4UJ2pj6cCiof6sxz7s=";
  };

  vendorHash = "sha256-CCtWsljI14VOGjPid6ouzvieDbylh9ljoUcAoR9r4b4=";

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
