{ lib, buildPythonPackage, fetchPypi, isPy3k, substituteAll, aiodns, pyasn1, pyasn1-modules, aiohttp, gnupg, nose }:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.7.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fy7sRKS7ih4JmjOW/noL8qJ1xWVpQLbBbObHnMwT3Bc=";
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
