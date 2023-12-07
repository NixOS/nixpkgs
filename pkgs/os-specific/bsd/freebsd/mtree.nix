{ mkDerivation, patchesRoot, libnetbsd, hostArchBsd, ... }:
mkDerivation {
  path = "contrib/mtree";
  extraPaths = [ "contrib/mknod" "sbin/mknod" "sys" "include" "lib/libnetbsd" "lib/libutil" "lib/libmd" ];
  #buildInputs = [libnetbsd];

  patches = [ /${patchesRoot}/mtree-Makefile.patch ];

  postPatch = ''
    ln -s $BSDSRCDIR/contrib/mknod/*.c $BSDSRCDIR/contrib/mknod/*.h $BSDSRCDIR/contrib/mtree
    ln -s $BSDSRCDIR/sys/${hostArchBsd}/include $BSDSRCDIR/sys/machine
    ln -s $BSDSRCDIR/sys/x86/include/*.h $BSDSRCDIR/sys/x86   # uhhhhhhhh
  '';
  NIX_DEBUG=1;
}
