{ lib, buildGoModule, fetchurl }:
import ./versions.nix ({version, sha256}:
  buildGoModule {
  pname = "honeytail";
  inherit version;
  vendorSha256 = "sha256-LtiiLGLjhbfT49A6Fw5CbSbnmTHMxtcUssr+ayCVrvY=";

  src = fetchurl {
    url = "https://github.com/honeycombio/honeytail/archive/refs/tags/v${version}.tar.gz";
    inherit sha256;
  };
  inherit (buildGoModule.go) GOOS GOARCH;

  meta = with lib; {
    description = "agent for ingesting log file data into honeycomb.io and making it available for exploration";
    homepage = "https://honeycomb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.iand675 ];
  };
})

