{ stdenvNoCC, buildPackages, MacOSX-SDK }:

let self = stdenvNoCC.mkDerivation {
  pname = "libnetwork";
  version = MacOSX-SDK.version;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib
    cp ${MacOSX-SDK}/usr/lib/libnetwork* $out/lib
  '';

  passthru = {
    tbdRewrites = {
      const."/usr/lib/libnetwork.dylib" = "${self}/lib/libnetwork.dylib";
    };
  };
}; in self
