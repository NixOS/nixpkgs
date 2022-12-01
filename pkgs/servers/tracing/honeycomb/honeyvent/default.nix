{ lib, buildGoModule, fetchurl }:
import ./versions.nix ({version, sha256}:
  buildGoModule {
  pname = "honeyvent";
  inherit version;
  vendorSha256 = null;

  src = fetchurl {
    url = "https://github.com/honeycombio/honeyvent/archive/refs/tags/v${version}.tar.gz";
    inherit sha256;
  };
  inherit (buildGoModule.go) GOOS GOARCH;

  meta = with lib; {
    description = "CLI for sending individual events to honeycomb.io";
    homepage = "https://honeycomb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.iand675 ];
  };
})

