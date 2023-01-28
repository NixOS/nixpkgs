{ stdenvNoCC, cacert, crystal, openssl, pkg-config, invidious }:

let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
in
stdenvNoCC.mkDerivation {
  name = "videojs";

  inherit (invidious) src;

  builder = ./videojs.sh;

  nativeBuildInputs = [ cacert crystal openssl pkg-config ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = versions.videojs.sha256;
}
