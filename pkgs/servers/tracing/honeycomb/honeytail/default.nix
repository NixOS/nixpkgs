{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
import ./versions.nix (
  { version, sha256 }:
  buildGoModule {
    pname = "honeytail";
    inherit version;
    vendorHash = "sha256-LtiiLGLjhbfT49A6Fw5CbSbnmTHMxtcUssr+ayCVrvY=";

    src = fetchFromGitHub {
      owner = "honeycombio";
      repo = "honeytail";
      rev = "v${version}";
      hash = sha256;
    };

    meta = {
      description = "agent for ingesting log file data into honeycomb.io and making it available for exploration";
      homepage = "https://honeycomb.io/";
      license = lib.licenses.asl20;
      maintainers = [ lib.maintainers.iand675 ];
    };
  }
)
