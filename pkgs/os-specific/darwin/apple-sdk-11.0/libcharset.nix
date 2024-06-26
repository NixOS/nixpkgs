{
  stdenvNoCC,
  buildPackages,
  MacOSX-SDK,
}:

stdenvNoCC.mkDerivation {
  pname = "libcharset";
  version = MacOSX-SDK.version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ buildPackages.darwin.checkReexportsHook ];

  installPhase = ''
    mkdir -p $out/{include,lib}
    cp ${MacOSX-SDK}/usr/lib/libcharset* $out/lib
  '';
}
