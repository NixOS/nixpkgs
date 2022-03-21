{ lib, buildGoModule, fetchurl }:
import ./versions.nix ({version, sha256}:
  buildGoModule {
  pname = "honeymarker";
  inherit version;
  vendorSha256 = "sha256-ZuDobjC/nizZ7G0o/zVTQmDfDjcdBhfPcmkhgwFc7VU=";

  src = fetchurl {
    url = "https://github.com/honeycombio/honeymarker/archive/refs/tags/v${version}.tar.gz";
    inherit sha256;
  };
  inherit (buildGoModule.go) GOOS GOARCH;

  meta = with lib; {
    description = "provides a simple CRUD interface for dealing with per-dataset markers on honeycomb.io";
    homepage = "https://honeycomb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.iand675 ];
  };
})

