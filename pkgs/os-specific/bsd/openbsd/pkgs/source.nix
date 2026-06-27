{
  lib,
  fetchcvs,
  version,
}:

fetchcvs {
  cvsRoot = "anoncvs@anoncvs.fr.openbsd.org/cvs";
  module = "src";
  tag = "OPENBSD_${lib.replaceStrings [ "." ] [ "_" ] version}_BASE";
  sha256 = "sha256-n6pkgjCvqAGpZzLZnsO8FT7HMtBH3i7SLfhFBqQ9jmE=";
}
