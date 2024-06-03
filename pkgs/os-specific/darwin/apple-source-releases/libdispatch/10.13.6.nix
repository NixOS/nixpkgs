{ lib, appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include/dispatch $out/include/os

    cp -r dispatch/*.h $out/include/dispatch
    cp -r os/object*.h  $out/include/os

    # gcc compatability. Source: https://stackoverflow.com/a/28014302/3714556
    substituteInPlace $out/include/dispatch/object.h \
      --replace-fail 'typedef void (^dispatch_block_t)(void);' \
                     '#ifdef __clang__
                      typedef void (^dispatch_block_t)(void);
                      #else
                      typedef void* dispatch_block_t;
                      #endif'
  '';

  appleHeaders = ''
    dispatch/base.h
    dispatch/block.h
    dispatch/data.h
    dispatch/dispatch.h
    dispatch/group.h
    dispatch/introspection.h
    dispatch/io.h
    dispatch/object.h
    dispatch/once.h
    dispatch/queue.h
    dispatch/semaphore.h
    dispatch/source.h
    dispatch/time.h
    os/object.h
    os/object_private.h
  '';

  meta = {
    maintainers = with lib.maintainers; [ toonn ];
  };
}
