{
  stdenvNoCC,
  buildPackages,
  MacOSX-SDK,
}:

let
  self = stdenvNoCC.mkDerivation {
    pname = "libcompression";
    version = MacOSX-SDK.version;

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/lib
      cp ${MacOSX-SDK}/usr/lib/libcompression* $out/lib
    '';

    passthru = {
      tbdRewrites = {
        const."/usr/lib/libcompression.dylib" = "${self}/lib/libcompression.dylib";
      };
    };
  };
in
self
