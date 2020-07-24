{ appleDerivation, lib, headersOnly ? false }:

appleDerivation {
  installPhase = lib.optionalString headersOnly ''
    mkdir -p $out/include/hfs
    cp core/*.h $out/include/hfs
  '';
}
