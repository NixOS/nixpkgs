{
  stdenvNoCC,
  buildPackages,
  MacOSX-SDK,
}:
stdenvNoCC.mkDerivation {
  inherit (MacOSX-SDK) version;
  pname = "libcharset";

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [buildPackages.darwin.checkReexportsHook];

  installPhase = ''
    mkdir -p $out/{include,lib}
    cp ${MacOSX-SDK}/usr/lib/libcharset* $out/lib
  '';
}
