{ lib, buildPythonPackage, fetchPypi, isPy3k, substituteAll, aiodns, pyasn1, pyasn1-modules, aiohttp, gnupg, nose }:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.5.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w9710gr0xpzs9jwi47g1gk73wypq3sr88mklrridyjciikl8l36";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-gnupg-path.patch;
      inherit gnupg;
    })
  ];

  propagatedBuildInputs = [ aiodns pyasn1 pyasn1-modules aiohttp ];

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests --where=tests --exclude=live -i slixtest.py
  '';

  meta = {
    description = "Elegant Python library for XMPP";
    license = lib.licenses.mit;
    homepage = "https://dev.louiz.org/projects/slixmpp";
  };
}
