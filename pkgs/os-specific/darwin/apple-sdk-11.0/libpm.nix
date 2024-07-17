{
  stdenvNoCC,
  MacOSX-SDK,
  checkReexportsHook,
}:

stdenvNoCC.mkDerivation {
  pname = "libpm";
  version = MacOSX-SDK.version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ checkReexportsHook ];

  installPhase = ''
    mkdir -p $out/lib
    cp ${MacOSX-SDK}/usr/lib/libpm* $out/lib
  '';

  passthru = {
    tbdRewrites = {
      const."/usr/lib/libpmenergy.dylib" = "${placeholder "out"}/lib/libpmenergy.dylib";
      const."/usr/lib/libpmsample.dylib" = "${placeholder "out"}/lib/libpmsample.dylib";
    };
  };
}
