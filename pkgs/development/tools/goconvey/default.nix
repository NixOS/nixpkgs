{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "goconvey";
  version = "1.6.3";

  goPackagePath = "github.com/smartystreets/goconvey";
  excludedPackages = "web/server/watch/integration_testing";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "smartystreets";
    repo = "goconvey";
    rev = "${version}";
    sha256 = "1ph18rkl3ns3fgin5i4j54w5a69grrmf3apcsmnpdn1wlrbs3dxh";
  };

  meta = {
    description = "Go testing in the browser. Integrates with `go test`. Write behavioral tests in Go.";
    homepage = https://github.com/smartystreets/goconvey;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
