{ stdenvNoCC, MacOSX-SDK, libcharset }:

let self = stdenvNoCC.mkDerivation {
  pname = "libobjc";
  version = MacOSX-SDK.version;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{include,lib}
    cp -r ${MacOSX-SDK}/usr/include/objc $out/include
    cp ${MacOSX-SDK}/usr/lib/libobjc* $out/lib
  '';

  passthru = {
    tbdRewrites = {
      const."/usr/lib/libobjc.A.dylib" = "${self}/lib/libobjc.A.dylib";
    };
  };
}; in self
