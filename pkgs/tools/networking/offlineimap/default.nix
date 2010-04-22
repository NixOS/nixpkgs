{fetchurl, buildPythonPackage}:

buildPythonPackage {
  name = "offlineimap-6.2.0";

  src = fetchurl {
    url = "http://software.complete.org/software/attachments/download/413/offlineimap_6.2.0.orig.tar.gz";
    sha256 = "057pcz2291mdpkjyrwdzxfg831337sg7bbqyxmwfy42k7np5bdi4";
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
