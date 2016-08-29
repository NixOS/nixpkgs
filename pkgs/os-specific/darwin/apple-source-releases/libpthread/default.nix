{ stdenv, appleDerivation, libdispatch, xnu }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  propagatedBuildInputs = [ libdispatch xnu ];

  installPhase = ''
    mkdir -p $out/include/pthread/
    mkdir -p $out/include/sys/_types
    cp pthread/*.h $out/include/pthread/

    # This overwrites qos.h, and is probably not necessary, but I'll leave it here for now
    # cp private/*.h $out/include/pthread/

    cp -r sys $out/include
    cp -r sys/_pthread/*.h $out/include/sys/_types/
  '';
}
