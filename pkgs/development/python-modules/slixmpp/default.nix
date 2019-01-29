{ lib, buildPythonPackage, fetchPypi, isPy3k, substituteAll, aiodns, pyasn1, pyasn1-modules, aiohttp, gnupg, nose }:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.4.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "020acd4507fd00c38835b78b5f338db60d3df840187623e0d41ab2ca89d7ae57";
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
    homepage = https://dev.louiz.org/projects/slixmpp;
  };
}
