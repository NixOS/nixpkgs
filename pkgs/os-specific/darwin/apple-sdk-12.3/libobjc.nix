{ stdenvNoCC, darwin-stubs }:

let
  self = stdenvNoCC.mkDerivation {
    pname = "libobjc";
    inherit (darwin-stubs) version;

    buildCommand = ''
      mkdir -p $out/{include,lib/swift}
      cp -r ${darwin-stubs}/usr/include/objc $out/include
      cp ${darwin-stubs}/usr/lib/libobjc* $out/lib
      cp -r ${darwin-stubs}/usr/lib/swift/ObjectiveC.swiftmodule $out/lib/swift
      cp ${darwin-stubs}/usr/lib/swift/libswiftObjectiveC.tbd $out/lib/swift
    '';

    passthru.tbdRewrites = {
      const."/usr/lib/libobjc.A.dylib" = "${self}/lib/libobjc.A.dylib";
      const."/usr/lib/swift/libswiftObjectiveC.dylib" = "${self}/lib/swift/libswiftObjectiveC.dylib";
    };
  };
in
self
