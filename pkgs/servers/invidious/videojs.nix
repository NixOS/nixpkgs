{ stdenvNoCC, cacert, crystal, openssl, pkg-config, invidious }:

stdenvNoCC.mkDerivation {
  name = "videojs";

  inherit (invidious) src;

  builder = ./videojs.sh;

  nativeBuildInputs = [ cacert crystal openssl pkg-config ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0b4vxd29kpvy60yhqm376r1872gds17s6wljqw0zlr16j762k50r";
}
