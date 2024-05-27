{mkKdeDerivation}:
mkKdeDerivation {
  pname = "kpackage";

  # Follow symlinks when resolving packages
  # FIXME(later): upstream
  patches = [./follow-symlinks.patch];
  meta.mainProgram = "kpackagetool6";
}
