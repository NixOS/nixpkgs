{ lib, mkDerivation }:
mkDerivation {
  path = "usr.bin/getcap";
  meta = {
    description = "OpenBSD capability database lookup utility";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "getcap";
    platforms = lib.platforms.openbsd;
  };
}
