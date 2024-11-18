{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
  version = "2.13.0.0.1";
  sha256 = "oZgyJ2mPxpgsV2Le29XM+NsjMhqvDQ70SUZ2gjYg5U8=";
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
