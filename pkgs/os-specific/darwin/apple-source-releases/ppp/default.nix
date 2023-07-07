{ appleDerivation', stdenv }:

appleDerivation' stdenv {
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include/ppp

    cp Controller/ppp_msg.h                    $out/include/ppp
    cp Controller/pppcontroller_types.h        $out/include/ppp
    cp Controller/pppcontroller_types.h        $out/include
    cp Controller/pppcontroller.defs           $out/include/ppp
    cp Controller/pppcontroller_mach_defines.h $out/include
    cp Controller/PPPControllerPriv.h          $out/include/ppp
  '';
}
