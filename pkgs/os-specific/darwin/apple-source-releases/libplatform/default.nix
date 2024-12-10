{
  lib,
  appleDerivation',
  stdenvNoCC,
}:

appleDerivation' stdenvNoCC (finalAttrs: {
  installPhase = ''
    mkdir $out
    cp -r include $out/include
    test -d private && cp -r private/* $out/include
  '';

  appleHeaders =
    ''
      _simple.h
      libkern/OSAtomic.h
      libkern/OSAtomicDeprecated.h
      libkern/OSAtomicQueue.h
      libkern/OSCacheControl.h
      libkern/OSSpinLockDeprecated.h
      os/alloc_once_impl.h
      os/base.h
      os/base_private.h
      os/internal/atomic.h
      os/internal/crashlog.h
      os/internal/internal_shared.h
      os/lock.h
      os/lock_private.h
      os/once_private.h
      os/semaphore_private.h
      platform/compat.h
      platform/introspection_private.h
      platform/string.h
      setjmp.h
    ''
    + (
      if lib.versionAtLeast finalAttrs.version "254.40.4" then
        ''
          string_x86.h
          ucontext.h
        ''
      else
        ''
          ucontext.h
        ''
    );
})
