{ lib, appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  installPhase = ''
    mkdir $out
    cp -r include $out/include
  '';

  appleHeaders = ''
    libkern/OSAtomic.h
    libkern/OSAtomicDeprecated.h
    libkern/OSAtomicQueue.h
    libkern/OSCacheControl.h
    libkern/OSSpinLockDeprecated.h
    os/base.h
    os/lock.h
    setjmp.h
    ucontext.h
  '';

  meta = {
    maintainers = with lib.maintainers; [ toonn ];
  };
}
