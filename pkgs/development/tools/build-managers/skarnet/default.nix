{ stdenv }:

let

  version = "2014-11-28";

in stdenv.mkDerivation {

  name = "skarnet-conf-compile-${version}";

  phases = [ "fixupPhase" ];

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://www.skarnet.org/software/conf-compile.html;
    description = "Support for configuring skarnet.org packages for nix builds";
    platforms = stdenv.lib.platforms.all;
  };

}
