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

    meta = with lib; {
      description = "CLI for sending individual events to honeycomb.io";
      homepage = "https://honeycomb.io/";
      license = licenses.asl20;
      maintainers = [ maintainers.iand675 ];
    };
  }
)
