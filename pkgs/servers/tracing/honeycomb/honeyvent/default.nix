{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
import ./versions.nix (
  { version, sha256 }:
  buildGoModule {
    pname = "honeyvent";
    inherit version;
    vendorHash = null;

    src = fetchFromGitHub {
      owner = "honeycombio";
      repo = "honeyvent";
      rev = "v${version}";
      hash = sha256;
    };

    meta = {
      description = "CLI for sending individual events to honeycomb.io";
      homepage = "https://honeycomb.io/";
      license = lib.licenses.asl20;
      maintainers = [ lib.maintainers.iand675 ];
    };
  }
)
