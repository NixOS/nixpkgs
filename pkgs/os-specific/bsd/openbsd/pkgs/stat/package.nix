{ lib, mkDerivation }:
mkDerivation {
  path = "usr.bin/stat";
  meta = {
    description = "OpenBSD file status utility";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "stat";
    platforms = lib.platforms.openbsd;
  };
}
