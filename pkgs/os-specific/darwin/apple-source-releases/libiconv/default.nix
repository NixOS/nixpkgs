{ stdenv, appleDerivation, lib
, enableStatic ? stdenv.targetPlatform.isiOS
, enableShared ? !stdenv.targetPlatform.isiOS
}:

appleDerivation {
  postUnpack = "sourceRoot=$sourceRoot/libiconv";

  preConfigure = lib.optionalString stdenv.hostPlatform.isiOS ''
    sed -i 's/darwin\*/ios\*/g' configure libcharset/configure
  '';

  configureFlags = [
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
  ];

  postInstall = lib.optionalString enableShared ''
    mv $out/lib/libiconv.dylib $out/lib/libiconv-nocharset.dylib
    ${stdenv.cc.bintools.targetPrefix}install_name_tool -id $out/lib/libiconv-nocharset.dylib $out/lib/libiconv-nocharset.dylib

    # re-export one useless symbol; ld will reject a dylib that only reexports other dylibs
    echo 'void dont_use_this(){}' | ${stdenv.cc.bintools.targetPrefix}clang -dynamiclib -x c - -current_version 2.4.0 \
      -compatibility_version 7.0.0 -current_version 7.0.0 -o $out/lib/libiconv.dylib \
      -Wl,-reexport_library -Wl,$out/lib/libiconv-nocharset.dylib \
      -Wl,-reexport_library -Wl,$out/lib/libcharset.dylib
  '';

  setupHooks = [
    ../../../../build-support/setup-hooks/role.bash
    ../../../../development/libraries/libiconv/setup-hook.sh
  ];

  meta = {
    platforms = lib.platforms.darwin;
  };
}
