{ lib, buildManPages }:

buildManPages {
  pname = "s6-portable-utils-man-pages";
  version = "2.2.5.0.1";
  sha256 = "sha256-pIh+PKqKJTkaHyYrbWEEzdGDSzEO9E+ekTovu4SVSs4=";
  description = "Port of the documentation for the s6-portable-utils suite to mdoc";
  maintainers = [ lib.maintainers.somasis ];
}
