{ stdenv, appleDerivation }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/include/dispatch $out/include/os

    # Move these headers so CF can find <os/voucher_private.h>
    mv private/voucher*.h  $out/include/os
    cp -r private/*.h  $out/include/dispatch

    cp -r dispatch/*.h $out/include/dispatch
    cp -r os/object*.h  $out/include/os
  '';
}
