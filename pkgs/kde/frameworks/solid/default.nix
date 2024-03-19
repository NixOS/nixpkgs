{
  mkKdeDerivation,
  qttools,
  bison,
  flex,
  libimobiledevice,
}:
mkKdeDerivation {
  pname = "solid";

  # Also search /run/wrappers for mount/umount
  patches = [./fix-search-path.patch];

  extraNativeBuildInputs = [qttools bison flex];
  extraBuildInputs = [libimobiledevice];
  meta.mainProgram = "solid-hardware6";
}
