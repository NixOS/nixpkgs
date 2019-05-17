{ appleDerivation }:

appleDerivation {
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include/dispatch $out/include/os

    cp os/voucher*.h  $out/include/os
    cp private/*.h  $out/include/dispatch

    cp dispatch/*.h $out/include/dispatch
    cp os/object*.h  $out/include/os
  '';
}
