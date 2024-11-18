{ lib, buildManPages }:

buildManPages {
  pname = "s6-networking-man-pages";
  version = "2.7.0.3.1";
  sha256 = "9u2C1TF9vma+7Qo+00uZ6eOCn/9eMgKALgHDVgMcrfg=";
  description = "Port of the documentation for the s6-networking suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
