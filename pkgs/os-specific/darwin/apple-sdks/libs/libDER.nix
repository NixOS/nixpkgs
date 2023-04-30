{
  MacOSX-SDK,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (MacOSX-SDK) version;
  pname = "apple-lib-libDER";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/include
    cp -r ${MacOSX-SDK}/usr/include/libDER $out/include
  '';
}
