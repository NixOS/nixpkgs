{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
  version = "2.12.0.2.1";
  sha256 = "sha256-fFU+cRwXb4SwHsI/r0ghuzCf6hEK/muPPp2XMvD8VtQ=";
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
