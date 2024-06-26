{
  stdenvNoCC,
  buildPackages,
  MacOSX-SDK,
}:

stdenvNoCC.mkDerivation {
  pname = "libunwind";
  version = MacOSX-SDK.version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ buildPackages.darwin.checkReexportsHook ];

  installPhase = ''
    mkdir -p $out/include/mach-o

    cp \
      ${MacOSX-SDK}/usr/include/libunwind.h \
      ${MacOSX-SDK}/usr/include/unwind.h \
      $out/include

    cp \
      ${MacOSX-SDK}/usr/include/mach-o/compact_unwind_encoding.h \
      $out/include/mach-o
  '';
}
