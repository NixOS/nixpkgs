{ fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  version = "6.5.3";
  name = "offlineimap-${version}";

  src = fetchurl {
    url = "https://github.com/spaetz/offlineimap/tarball/v${version}";
    name = "${name}.tar.bz";
    sha256 = "8717a56e6244b47b908b23b598efb3470d74450ecd881b6d3573d8aec4a5db38";
  };

  doCheck = false;

  meta = {
    description = "OfflineImap synchronizes emails between two repositories, so that you can read the same mailbox from multiple computers.";
    homepage = "http://offlineimap.org";
    license = "GPLv2+";
  };
}
