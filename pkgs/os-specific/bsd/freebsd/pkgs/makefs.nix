{
  mkDerivation,
  libnetbsd,
  compatIfNeeded,
  libsbuf,
}:
mkDerivation {
  path = "usr.sbin/makefs";
  extraPaths = [
    "stand/libsa"
    "sys/cddl/boot"
    "sys/ufs/ffs"
    "sbin/newfs_msdos"
    "contrib/mtree"
    "contrib/mknod"
    "sys/fs/cd9660"
  ];
  buildInputs = compatIfNeeded ++ [
    libnetbsd
    libsbuf
  ];
  MK_TESTS = "no";
  MK_PIE = "no";
}
