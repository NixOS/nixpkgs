{ lib, buildPythonPackage, pythonOlder, fetchurl, aiodns, pyasn1, pyasn1-modules, gnupg }:
buildPythonPackage rec {
  name = "slixmpp-${version}";
  version = "1.4.0";

  disabled = pythonOlder "3.4";

  src = fetchurl {
    url = "mirror://pypi/s/slixmpp/${name}.tar.gz";
    sha256 = "155qxx4xlkkjb4hphc09nsi2mi4xi3m2akg0z7064kj3nbzkwjn2";
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
