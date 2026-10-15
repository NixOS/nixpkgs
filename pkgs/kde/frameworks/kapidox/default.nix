{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kapidox";

  # doesn't actually install anything - good thing it's unused
  meta.broken = true;
}
