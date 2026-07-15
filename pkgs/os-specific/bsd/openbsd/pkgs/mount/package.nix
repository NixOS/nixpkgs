{
  mkDerivation,
}:

mkDerivation {
  path = "sbin/mount";
  meta.mainProgram = "mount";
  patches = [ ./search-path.patch ];
}
