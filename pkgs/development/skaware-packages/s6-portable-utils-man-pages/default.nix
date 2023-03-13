{ lib, buildManPages }:

buildManPages {
  pname = "s6-portable-utils-man-pages";
  version = "2.2.5.1.1";
  sha256 = "5up4IfsoHJGYwnDJVnnPWU9sSWS6qq+/6ICtHYjI6pg=";
  description = "Port of the documentation for the s6-portable-utils suite to mdoc";
  maintainers = [ lib.maintainers.somasis ];
}
