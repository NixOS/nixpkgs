{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include/dispatch $out/include/os

    # Move these headers so CF can find <os/voucher_private.h>
    mv private/voucher*.h  $out/include/os
    cp -r private/*.h  $out/include/dispatch

    cp -r dispatch/*.h $out/include/dispatch
    cp -r os/object*.h  $out/include/os

    # gcc compatibility. Source: https://stackoverflow.com/a/28014302/3714556
    substituteInPlace $out/include/dispatch/object.h \
      --replace 'typedef void (^dispatch_block_t)(void);' \
                '#ifdef __clang__
                 typedef void (^dispatch_block_t)(void);
                 #else
                 typedef void* dispatch_block_t;
                 #endif'
  '';

  appleHeaders = ''
    dispatch/base.h
    dispatch/benchmark.h
    dispatch/block.h
    dispatch/data.h
    dispatch/data_private.h
    dispatch/dispatch.h
    dispatch/group.h
    dispatch/introspection.h
    dispatch/introspection_private.h
    dispatch/io.h
    dispatch/io_private.h
    dispatch/layout_private.h
    dispatch/mach_private.h
    dispatch/object.h
    dispatch/once.h
    dispatch/private.h
    dispatch/queue.h
    dispatch/queue_private.h
    dispatch/semaphore.h
    dispatch/source.h
    dispatch/source_private.h
    dispatch/time.h
    os/object.h
    os/object_private.h
    os/voucher_activity_private.h
    os/voucher_private.h
  '';
}
