{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
  version = "2.11.3.2.4";
  sha256 = "02dmccmcwssv8bkzs3dlbnwl6kkp1crlbnlv5ljbrgm26klw9rc7";
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
