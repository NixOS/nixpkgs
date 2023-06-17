{ lib, buildManPages }:

buildManPages {
  pname = "execline-man-pages";
  version = "2.9.0.0.1";
  sha256 = "sha256-hT0YsuYJ3XSMYwtlwDR8PGlD8ng8XPky93rCprruHu8=";
  description = "Port of the documentation for the execline suite to mdoc";
  maintainers = [ lib.maintainers.sternenseemann ];
}
