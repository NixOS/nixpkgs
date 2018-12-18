{ appleDerivation, lib, headersOnly ? false }:

appleDerivation {
  installPhase = lib.optionalString headersOnly ''
    mkdir -p $out/include
    cp core/*.h $out/include
  '';
}
