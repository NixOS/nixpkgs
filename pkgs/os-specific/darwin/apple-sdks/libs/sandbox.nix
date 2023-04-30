{
  MacOSX-SDK,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (MacOSX-SDK) version;
  pname = "apple-lib-sandbox";
  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include $out/lib
    ln -s "${MacOSX-SDK}/usr/include/sandbox.h" $out/include/sandbox.h
    cp "${MacOSX-SDK}/usr/lib/libsandbox.1.tbd" $out/lib
    ln -s libsandbox.1.tbd $out/lib/libsandbox.tbd
  '';
}
