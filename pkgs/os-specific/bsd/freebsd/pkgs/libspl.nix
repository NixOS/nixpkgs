{ lib, mkDerivation }:

mkDerivation {
  path = "cddl/lib/libspl";
  extraPaths = [
    "sys/contrib/openzfs/lib/libspl"
    "sys/contrib/openzfs/include"

    "cddl/compat/opensolaris/include"
    "sys/contrib/openzfs/module/icp/include"
    "sys/modules/zfs"
  ];
  # nativeBuildInputs = [
  #   bsdSetupHook freebsdSetupHook
  #   makeMinimal install mandoc groff

  #   flex byacc file2c
  # ];
  # buildInputs = compatIfNeeded ++ [ libnv libsbuf ];
  meta.license = lib.licenses.cddl;
}
