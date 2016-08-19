{ stdenv, appleDerivation, libdispatch, xnu }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  propagatedBuildInputs = [ libdispatch xnu ];

  installPhase = ''
    mkdir -p $out/include/pthread
    cp pthread/*.h $out/include/pthread/
    cp private/*.h $out/include/pthread/
  '';
}
