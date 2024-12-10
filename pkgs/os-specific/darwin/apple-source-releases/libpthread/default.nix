{
  lib,
  appleDerivation',
  stdenvNoCC,
  libdispatch,
  xnu,
}:

appleDerivation' stdenvNoCC {
  propagatedBuildInputs = [
    libdispatch
    xnu
  ];

  installPhase = ''
    mkdir -p $out/include/pthread/
    mkdir -p $out/include/sys/_types
    cp pthread/*.h $out/include/pthread/

    # This overwrites qos.h, and is probably not necessary, but I'll leave it here for now
    # cp private/*.h $out/include/pthread/

    cp -r sys $out/include
    cp -r sys/_pthread/*.h $out/include/sys/_types/
  '';

  appleHeaders = ''
    pthread/introspection.h
    pthread/pthread.h
    pthread/pthread_impl.h
    pthread/pthread_spis.h
    pthread/qos.h
    pthread/sched.h
    pthread/spawn.h
    sys/_pthread/_pthread_attr_t.h
    sys/_pthread/_pthread_cond_t.h
    sys/_pthread/_pthread_condattr_t.h
    sys/_pthread/_pthread_key_t.h
    sys/_pthread/_pthread_mutex_t.h
    sys/_pthread/_pthread_mutexattr_t.h
    sys/_pthread/_pthread_once_t.h
    sys/_pthread/_pthread_rwlock_t.h
    sys/_pthread/_pthread_rwlockattr_t.h
    sys/_pthread/_pthread_t.h
    sys/_pthread/_pthread_types.h
    sys/_types/_pthread_attr_t.h
    sys/_types/_pthread_cond_t.h
    sys/_types/_pthread_condattr_t.h
    sys/_types/_pthread_key_t.h
    sys/_types/_pthread_mutex_t.h
    sys/_types/_pthread_mutexattr_t.h
    sys/_types/_pthread_once_t.h
    sys/_types/_pthread_rwlock_t.h
    sys/_types/_pthread_rwlockattr_t.h
    sys/_types/_pthread_t.h
    sys/_types/_pthread_types.h
    sys/qos.h
    sys/qos_private.h
  '';

  meta = {
    platforms = lib.platforms.darwin;
  };
}
