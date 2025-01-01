{ stdenvNoCC, darwin-stubs }:

let
  self = stdenvNoCC.mkDerivation {
    pname = "libnetwork";
    inherit (darwin-stubs) version;

    buildCommand = ''
      mkdir -p $out/lib
      cp ${darwin-stubs}/usr/lib/libnetwork* $out/lib
    '';

    passthru.tbdRewrites.const."/usr/lib/libnetwork.dylib" = "${self}/lib/libnetwork.dylib";
  };
in
self
