{
  stdenvNoCC,
  buildPackages,
  darwin-stubs,
}:

stdenvNoCC.mkDerivation {
  pname = "libpm";
  inherit (darwin-stubs) version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ buildPackages.darwin.checkReexportsHook ];

  installPhase = ''
    mkdir -p $out/lib
    cp ${darwin-stubs}/usr/lib/libpm* $out/lib
  '';

  passthru.tbdRewrites = {
    const."/usr/lib/libpmenergy.dylib" = "${placeholder "out"}/lib/libpmenergy.dylib";
    const."/usr/lib/libpmsample.dylib" = "${placeholder "out"}/lib/libpmsample.dylib";
  };
}
