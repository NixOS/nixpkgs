{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kservice";

  # FIXME(later): the whole sycoca situation is very bad
  patches = [
    # explode less when sycoca is deleted
    ./handle-sycoca-deletion.patch
  ];
  meta.mainProgram = "kbuildsycoca6";
}
