{
  lib,
  fetchcvs,
  version,
}:

fetchcvs {
  cvsRoot = "anoncvs@anoncvs.fr.openbsd.org/cvs";
  module = "src";
  tag = "OPENBSD_${lib.replaceStrings [ "." ] [ "_" ] version}_BASE";
  sha256 = "sha256-bA2o0Bco+AsJr3RON8WTzjd0E+hyObNEv0VNzMsr99k=";
}
