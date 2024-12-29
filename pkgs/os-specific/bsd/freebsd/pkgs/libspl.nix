{ lib, mkDerivation }:

mkDerivation {
  path = "cddl/lib/libspl";
  extraPaths = [
    "cddl/compat/opensolaris/include"
    "sys/contrib/openzfs/include"
    "sys/contrib/openzfs/lib/libspl"
    "sys/contrib/openzfs/module/icp/include"
    "sys/modules/zfs/zfs_config.h"
  ];

  # Without a prefix it will try to put object files in nonexistant directories
  preBuild = ''
    export MAKEOBJDIRPREFIX=$TMP/obj
  '';

  meta = with lib; {
    platform = platforms.freebsd;
    license = licenses.cddl;
  };
}
