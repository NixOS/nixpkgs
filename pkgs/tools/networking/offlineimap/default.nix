{ fetchurl, buildPythonPackage }:

buildPythonPackage {
  name = "offlineimap-6.2.0.2";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/o/offlineimap/offlineimap_6.2.0.2.orig.tar.gz";
    sha256 = "1w69qv1dm37m53k8cd068lk5z3qjlscnjxr397gs8kdsfds67v7c";
  };

  doCheck = false;

  meta = {
    description = "IMAP to local files bridge";
    homepage = "http://software.complete.org/software/projects/show/offlineimap";
    license = "GPLv2+";
  };
}
