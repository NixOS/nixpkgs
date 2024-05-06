{
  mkKdeDerivation,
  fetchpatch,
  qttools,
  bison,
  flex,
  libimobiledevice,
}:
mkKdeDerivation {
  pname = "solid";

  patches = [
    # Also search /run/wrappers for mount/umount
    ./fix-search-path.patch

    # Backport fix for mounting removable LUKS devices
    # FIXME: remove in 6.2
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/solid/-/commit/a3b18591ba144fae0cd0cfc087a45c64000d4e51.patch";
      hash = "sha256-e7+amjOShUSzPb0pAxnAuuh/fbK/YLESqR0co1bs+wg=";
    })
  ];

  extraNativeBuildInputs = [qttools bison flex];
  extraBuildInputs = [libimobiledevice];
  meta.mainProgram = "solid-hardware6";
}
