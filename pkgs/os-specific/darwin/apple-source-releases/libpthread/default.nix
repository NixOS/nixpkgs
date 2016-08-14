{ stdenv, appleDerivation, libdispatch, xnu }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  propagatedBuildInputs = [ libdispatch xnu ];

  installPhase = ''
    mkdir -p $out/include/pthread/
    mkdir -p $out/include/sys/_types
    cp pthread/*.h $out/include/pthread/
    cp private/*.h $out/include/pthread/
    cp -r sys $out/include
    cp -r sys/_pthread/*.h $out/include/sys/_types/

  '';
}
