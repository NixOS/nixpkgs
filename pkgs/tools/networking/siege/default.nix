{ stdenv, fetchurl, lib }:
let
  version = "3.0.5";
  baseName = "siege";
in stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  src = fetchurl {
    url = "http://www.joedog.org/pub/siege/${name}.tar.gz";
    sha256 = "16faa6kappg23bdriyiy3ym94rmddpvw8cl8xgv5nxq2v17n4gi8";
  };
  meta = {
    description = "HTTP load tester";
    maintainers = with lib.maintainers; [ ocharles raskin ];
    platforms = with lib.platforms; linux;
    license = with lib.licenses; gpl2Plus;
  };
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";
}
