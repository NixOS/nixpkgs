{
  mkDerivation,
  lib,
  libbsdxml,
  libgeom,
  openssl,
  zfs-data,
  zlib,
}:
# When I told you this was libzfs, I lied.
# This is actually all the openzfs libs.
# We need to build a bunch of them before libzfs otherwise it complains
# For the dependency tree see sys/contrib/openzfs/lib/Makefile.am
# or cddl/lib/Makefile
let
  libs = [
    # Not really "zfs" libraries, they're solaris compatibility libraries
    "libspl"
    "libumem"

    # Libraries with no dependencies here except libumem and libspl
    "libavl"
    "libicp"
    "libnvpair"
    "libtpool"

    # Depend only on the previous ones
    "libzutil"
    "libzfs_core"
    "libuutil"

    # Final libraries
    "libzpool"
    "libzfs"
  ];
in
mkDerivation {
  path = "cddl/lib/libzfs";
  extraPaths = [
    "cddl/Makefile.inc"
    "cddl/compat/opensolaris"
    "cddl/lib"
    "sys/contrib/openzfs"
    "sys/modules/zfs"
  ];

  buildInputs = [
    libbsdxml
    libgeom
    openssl
    zlib
  ];

  postPatch = ''
    # libnvpair uses `struct xdr_bytesrec`, which is never defined when this is set
    # no idea how this works upstream
    sed -i 's/-DHAVE_XDR_BYTESREC//' $BSDSRCDIR/cddl/lib/libnvpair/Makefile

    # libzfs wants some files from compatibility.d, put them in the store
    sed -i 's|/usr/share/zfs|${zfs-data}/share/zfs|' $BSDSRCDIR/cddl/lib/libzfs/Makefile
  '';

  # If we don't specify an object directory then
  # make will try to put openzfs objects in nonexistent directories.
  # This one seems to work
  preBuild = ''
    export MAKEOBJDIRPREFIX=$BSDSRCDIR/obj
  ''
  + lib.flip lib.concatMapStrings libs (libname: ''
    echo "building dependency ${libname}"
    make -C $BSDSRCDIR/cddl/lib/${libname} $makeFlags
    make -C $BSDSRCDIR/cddl/lib/${libname} $makeFlags install
  '');

  outputs = [
    "out"
    "debug"
  ];

  meta = {
    platforms = lib.platforms.freebsd;
    license = with lib.licenses; [ cddl ];
  };
}
