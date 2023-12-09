{ mkDerivation, patchesRoot, libnetbsd, libmd, compatIfNeeded, ... }:
mkDerivation {
  path = "contrib/mtree";
  extraPaths = [ "contrib/mknod" ];
  buildInputs = compatIfNeeded ++ [libmd libnetbsd];

  patches = [ /${patchesRoot}/mtree-Makefile.patch ];

  postPatch = ''
    ln -s $BSDSRCDIR/contrib/mknod/*.c $BSDSRCDIR/contrib/mknod/*.h $BSDSRCDIR/contrib/mtree
  '';
  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lmd -lnetbsd -legacy"
  '';
}
