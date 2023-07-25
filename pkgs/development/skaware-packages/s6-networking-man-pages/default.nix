{ lib, buildManPages }:

buildManPages {
  pname = "s6-networking-man-pages";
  version = "2.5.1.3.3";
  sha256 = "02ba5jyfpbib402mfl42pbbdxyjy2vhpiz1b2qdg4ax58yr4jzqk";
  description = "Port of the documentation for the s6-networking suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
