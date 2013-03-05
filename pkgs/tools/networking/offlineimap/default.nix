{ pkgs, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  version = "6.5.5-rc2";
  name = "offlineimap-${version}";

  src = fetchurl {
    url = "https://github.com/OfflineIMAP/offlineimap/tarball/v${version}";
    name = "${name}.tar.bz";
    sha256 = "03w3irh8pxwvivi139xm5iaj2f8vmriak1ispq9d9f84z1098pd3";
  };

  doCheck = false;

  meta = {
    description = "OfflineImap synchronizes emails between two repositories, so that you can read the same mailbox from multiple computers.";
    homepage = "http://offlineimap.org";
    license = pkgs.lib.licenses.gpl2Plus;
    maintainers = [ pkgs.lib.maintainers.garbas ];
  };
}
