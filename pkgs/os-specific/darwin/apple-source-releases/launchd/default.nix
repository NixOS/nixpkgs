{ appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  # No clue why the same file has two different names. Ask Apple!
  installPhase = ''
    mkdir -p $out/include/ $out/include/servers
    cp liblaunch/*.h $out/include

    cp liblaunch/bootstrap.h $out/include/servers
    cp liblaunch/bootstrap.h $out/include/servers/bootstrap_defs.h
  '';

  appleHeaders = ''
    bootstrap.h
    bootstrap_priv.h
    launch.h
    launch_internal.h
    launch_priv.h
    reboot2.h
    servers/bootstrap.h
    servers/bootstrap_defs.h
    vproc.h
    vproc_internal.h
    vproc_priv.h
  '';
}
