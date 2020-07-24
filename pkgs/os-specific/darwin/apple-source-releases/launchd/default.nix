{ appleDerivation }:

appleDerivation {
  # No clue why the same file has two different names. Ask Apple!
  installPhase = ''
    mkdir -p $out/include/ $out/include/servers
    cp liblaunch/*.h $out/include

    cp liblaunch/bootstrap.h $out/include/servers
    cp liblaunch/bootstrap.h $out/include/servers/bootstrap_defs.h
  '';
}
