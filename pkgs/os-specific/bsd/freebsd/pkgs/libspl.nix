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

  # Without a prefix it will try to put object files in nonexistent directories
  preBuild = ''
    export MAKEOBJDIRPREFIX=$TMP/obj
  '';

  alwaysKeepStatic = true;

<<<<<<< HEAD
  meta = {
    license = lib.licenses.cddl;
=======
  meta = with lib; {
    platforms = platforms.freebsd;
    license = licenses.cddl;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
