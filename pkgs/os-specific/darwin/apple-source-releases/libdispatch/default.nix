{ appleDerivation }:

appleDerivation {
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include/dispatch $out/include/os

    # TODO(burke): this doesn't exist anymore
    # Move these headers so CF can find <os/voucher_private.h>
    # mv private/voucher*.h  $out/include/os
    cp -r private/*.h  $out/include/dispatch

    cp -r dispatch/*.h $out/include/dispatch
    cp -r os/object*.h  $out/include/os
  '';
}
