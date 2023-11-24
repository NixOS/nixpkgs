{ lib, buildManPages }:

buildManPages {
  pname = "s6-portable-utils-man-pages";
  version = "2.3.0.2.2";
  sha256 = "0zbxr6jqrx53z1gzfr31nm78wjfmyjvjx7216l527nxl9zn8nnv1";
  description = "Port of the documentation for the s6-portable-utils suite to mdoc";
  maintainers = [ lib.maintainers.somasis ];
}
