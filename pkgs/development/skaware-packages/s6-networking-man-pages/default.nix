{ lib, buildManPages }:

buildManPages {
  pname = "s6-networking-man-pages";
  version = "2.5.1.2.1";
  sha256 = "ffTfHqINi0vXGVHbk926U48fxZInrn4AMlSqODOWevo=";
  description = "Port of the documentation for the s6-networking suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
