{ mkDerivation, lib }:
mkDerivation {
  path = "cddl/share/zfs/compatibility.d";
  extraPaths = [ "sys/contrib/openzfs/cmd/zpool/compatibility.d" ];

  meta = {
    license = lib.licenses.cddl;
  };
}
