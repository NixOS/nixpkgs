{ stdenv, fetchurl, lib }:
let
  version = "3.0.6";
  baseName = "siege";
in stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  src = fetchurl {
    url = "http://www.joedog.org/pub/siege/${name}.tar.gz";
    sha256 = "0nwcj2s804z7yd20pa0cl010m0qgf22a02305i9jwxynwdj9kdvq";
  };
  meta = {
    description = "HTTP load tester";
    maintainers = with lib.maintainers; [ ocharles raskin ];
    platforms = with lib.platforms; linux;
    license = with lib.licenses; gpl2Plus;
  };
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";
}
