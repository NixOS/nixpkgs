{
  mkDerivation,
  lib,
  libgeom,
  libjail,
  libzfs,
  openssl,
  zfs-data,
}:
mkDerivation {
  path = "cddl/sbin/zfs";
  extraPaths = [
    "cddl/compat/opensolaris"
    "cddl/sbin/zpool"
    "sys/contrib/openzfs"
    "sys/modules/zfs"
  ];

  buildInputs = [
    libgeom
    libjail
    libzfs
    openssl
  ];

  postPatch = ''
    sed -i 's|/usr/share/zfs|${zfs-data}/share/zfs|' $BSDSRCDIR/cddl/sbin/zpool/Makefile
  '';

  # I lied, this is both zpool and zfs
  preBuild = ''
    make -C $BSDSRCDIR/cddl/sbin/zpool $makeFlags
    make -C $BSDSRCDIR/cddl/sbin/zpool $makeFlags install
  '';

  outputs = [
    "out"
    "man"
    "debug"
  ];

  meta = {
    platforms = lib.platforms.freebsd;
    license = with lib.licenses; [
      cddl
      bsd2
    ];
  };
}
