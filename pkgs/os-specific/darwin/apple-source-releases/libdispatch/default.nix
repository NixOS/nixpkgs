{ appleDerivation }:

appleDerivation {
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include/dispatch $out/include/os

    # Move these headers so CF can find <os/voucher_private.h>
    mv private/voucher*.h  $out/include/os
    cp -r private/*.h  $out/include/dispatch

    cp -r dispatch/*.h $out/include/dispatch
    cp -r os/object*.h  $out/include/os

    # gcc compatability. Source: https://stackoverflow.com/a/28014302/3714556
    substituteInPlace $out/include/dispatch/object.h \
      --replace 'typedef void (^dispatch_block_t)(void);' \
                '#ifdef __clang__
                 typedef void (^dispatch_block_t)(void);
                 #else
                 typedef void* dispatch_block_t;
                 #endif'
  '';
}
