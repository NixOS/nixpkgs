{
  mkKdeDerivation,
  bison,
  flex,
  libimobiledevice,
}:
mkKdeDerivation {
  pname = "solid";

  patches = [
    # Also search /run/wrappers for mount/umount
    ./fix-search-path.patch
  ];

  extraNativeBuildInputs = [
    bison
    flex
  ];
  extraBuildInputs = [ libimobiledevice ];
  meta.mainProgram = "solid-hardware6";
}
