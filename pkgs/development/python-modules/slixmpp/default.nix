{ lib, buildPythonPackage, fetchPypi, pythonOlder, fetchurl, aiodns, pyasn1, pyasn1-modules, gnupg }:

buildPythonPackage rec {
  pname = "slixmpp";
  version = "1.4.1";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "020acd4507fd00c38835b78b5f338db60d3df840187623e0d41ab2ca89d7ae57";
  };

  patchPhase = ''
    substituteInPlace slixmpp/thirdparty/gnupg.py \
      --replace "gpgbinary='gpg'" "gpgbinary='${gnupg}/bin/gpg'"
  '';

  propagatedBuildInputs = [ aiodns pyasn1 pyasn1-modules gnupg ];

  meta = {
    description = "Elegant Python library for XMPP";
    license = lib.licenses.mit;
    homepage = https://dev.louiz.org/projects/slixmpp;
  };
}
