{mkKdeDerivation}:
mkKdeDerivation {
  pname = "kservice";

  patches = [
    # follow symlinks when generating sycoca
    ./qdiriterator-follow-symlinks.patch
    # but not too much
    ./dont-overresolve-symlinks.patch
    # FIXME(later): upstream?
  ];
  meta.mainProgram = "kbuildsycoca6";
}
