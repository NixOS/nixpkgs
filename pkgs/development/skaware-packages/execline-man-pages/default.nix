{ lib, buildManPages }:

# Maintainer of manpages uses following versioning scheme: for every
# upstream $version he tags manpages release as ${version}.1, and,
# in case of extra fixes to manpages, new tags in form ${version}.2,
# ${version}.3 and so on are created.
buildManPages {
  pname = "execline-man-pages";
  version = "2.9.6.1.1";
  sha256 = "sha256-bj+74zTkGKLdLEb1k4iHfNI1lAuxLBASc5++m17Y0O8=";
  description = "Port of the documentation for the execline suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
