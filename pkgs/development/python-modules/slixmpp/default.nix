{ lib, buildPythonPackage, fetchPypi, isPy3k, substituteAll, aiodns, pyasn1, pyasn1-modules, aiohttp, gnupg, nose }:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.5.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c5g4r5c6zm5fgvk6dd0dbx9gl3ws2swajc5knlacnpfykwzp5b4";
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
