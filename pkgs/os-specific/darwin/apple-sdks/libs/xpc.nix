{
  MacOSX-SDK,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (MacOSX-SDK) version;
  pname = "apple-lib-xpc";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/include
    pushd $out/include >/dev/null
    cp -r "${MacOSX-SDK}/usr/include/xpc" $out/include/xpc
    cp "${MacOSX-SDK}/usr/include/launch.h" $out/include/launch.h
    popd >/dev/null
  '';
}
