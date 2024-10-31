{
  stdenvNoCC,
  buildPackages,
  darwin-stubs,
}:

stdenvNoCC.mkDerivation {
  pname = "libunwind";
  inherit (darwin-stubs) version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ buildPackages.darwin.checkReexportsHook ];

  installPhase = ''
    mkdir -p $out/include/mach-o

    cp \
      ${darwin-stubs}/usr/include/libunwind.h \
      ${darwin-stubs}/usr/include/unwind.h \
      $out/include

    cp \
      ${darwin-stubs}/usr/include/mach-o/compact_unwind_encoding.h \
      $out/include/mach-o
  '';
}
