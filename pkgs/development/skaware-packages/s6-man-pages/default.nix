{ lib, buildManPages }:

buildManPages {
  pname = "s6-man-pages";
  version = "2.11.2.0.1";
  sha256 = "LHpQgM+uMDdGYfdaMlhP1bA7Y4UgydUJaDJr7fZlq5Y=";
  description = "Port of the documentation for the s6 supervision suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
