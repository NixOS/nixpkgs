{fetchurl, buildPythonPackage}:

buildPythonPackage {
  name = "offlineimap-6.2.0.1";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/o/offlineimap/offlineimap_6.2.0.1.tar.gz";
    sha256 = "16s7whlw7vix54dil2ri871vyggr742agykk950lnlixcv66gyhn";
  };

  doCheck = false;

  preConfigure = "set -x";
  buildInputs = [ ];

  meta = {
    description = "IMAP to local files bridge";
    homepage = "http://software.complete.org/software/projects/show/offlineimap";
    license = "GPLv2+";
  };
}
