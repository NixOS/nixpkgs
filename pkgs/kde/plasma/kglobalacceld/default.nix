{mkKdeDerivation}:
mkKdeDerivation {
  pname = "kglobalacceld";

  # Don't delete shortcuts when applications disappear from sycoca,
  # because for us they sometimes do.
  # FIXME: make them actually not do that instead.
  patches = [./dont-delete-shortcuts.patch];
}
