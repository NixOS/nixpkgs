{ mkDerivation }:
mkDerivation {
  path = "sbin/fsck";

  patches = [ ./fsck-path.patch ];
}
