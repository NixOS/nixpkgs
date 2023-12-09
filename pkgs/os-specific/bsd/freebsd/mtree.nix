{ mkDerivation, patchesRoot, libnetbsd, libmd, compatIfNeeded, compatIsNeeded, lib, libutil, stdenv, ... }:
mkDerivation {
  path = "contrib/mtree";
  extraPaths = [ "contrib/mknod" ];
  buildInputs = compatIfNeeded ++ [libmd libnetbsd] ++ lib.optional (stdenv.isFreeBSD) libutil;

  patches = [ /${patchesRoot}/mtree-Makefile.patch ];

  postPatch = ''
    ln -s $BSDSRCDIR/contrib/mknod/*.c $BSDSRCDIR/contrib/mknod/*.h $BSDSRCDIR/contrib/mtree
  '';

  # _VA_LIST is required to prevent freebsd headers from clashing with clang headers
  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lmd -lnetbsd ${if compatIsNeeded then "-legacy" else ""} ${if stdenv.isFreeBSD then "-lutil" else ""}"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST"
  '';
}
