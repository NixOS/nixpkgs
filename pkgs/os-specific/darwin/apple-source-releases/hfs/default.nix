{ appleDerivation, lib, headersOnly ? false }:

appleDerivation {
  installPhase = lib.optionalString headersOnly ''
    mkdir -p $out/include/hfs
    cp core/*.h $out/include/hfs
  '';

  meta = {
    # Seems nobody wants its binary, so we didn't implement building.
    broken = !headersOnly;
    platforms = lib.platforms.darwin;
  };
}
