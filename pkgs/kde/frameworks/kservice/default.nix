{mkKdeDerivation}:
mkKdeDerivation {
  pname = "kservice";

  patches = [
    # follow symlinks when generating sycoca
    # FIXME(later): upstream
    ./qdiriterator-follow-symlinks.patch
  ];
  meta.mainProgram = "kbuildsycoca6";
}
