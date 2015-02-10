{ stdenv, appleDerivation }:

appleDerivation {
  preConfigure = "cd libiconv";

  postInstall = ''
    mv $out/lib/libiconv.dylib $out/lib/libiconv-nocharset.dylib
    install_name_tool -id $out/lib/libiconv-nocharset.dylib $out/lib/libiconv-nocharset.dylib

    ld -dylib -o $out/lib/libiconv.dylib \
      -reexport_library $out/lib/libiconv-nocharset.dylib \
      -reexport_library $out/lib/libcharset.dylib \
      -dylib_compatibility_version 7.0.0
  '';
}
