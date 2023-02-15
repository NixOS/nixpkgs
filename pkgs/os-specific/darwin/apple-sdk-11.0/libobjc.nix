{ stdenvNoCC, MacOSX-SDK, libcharset }:

let self = stdenvNoCC.mkDerivation {
  pname = "libobjc";
  version = MacOSX-SDK.version;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{include,lib/swift}
    cp -r ${MacOSX-SDK}/usr/include/objc $out/include
    cp ${MacOSX-SDK}/usr/lib/libobjc* $out/lib
    cp -r ${MacOSX-SDK}/usr/lib/swift/ObjectiveC.swiftmodule $out/lib/swift
    cp ${MacOSX-SDK}/usr/lib/swift/libswiftObjectiveC.tbd $out/lib/swift
  '';

  passthru = {
    tbdRewrites = {
      const."/usr/lib/libobjc.A.dylib" = "${self}/lib/libobjc.A.dylib";
      const."/usr/lib/swift/libswiftObjectiveC.dylib" = "${self}/lib/swift/libswiftObjectiveC.dylib";
    };
  };
}; in self
