{
  MacOSX-SDK,
  stdenv,
}:
stdenv.mkDerivation {
  inherit (MacOSX-SDK) version;
  pname = "apple-lib-utmp";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/include
    pushd $out/include >/dev/null
    ln -s "${MacOSX-SDK}/include/utmp.h"
    ln -s "${MacOSX-SDK}/include/utmpx.h"
    popd >/dev/null
  '';
}
