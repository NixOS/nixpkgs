{lib, buildPythonPackage, fetchPypi, isPy3k, incremental, ipaddress, twisted
, automat, zope_interface, idna, pyopenssl, service-identity, pytest, mock, lsof
, GeoIP}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "txtorcon";
  version = "0.20.0";

  checkInputs = [ pytest mock lsof GeoIP ];
  propagatedBuildInputs = [
    incremental twisted automat zope_interface
    # extra dependencies required by twisted[tls]
    idna pyopenssl service-identity
  ] ++ lib.optionals (!isPy3k) [ ipaddress ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc80cb76b3ddacef6d671c0a088cb1a45274c0858554c32ce55d0f41421c740e";
  };

  # ipaddress isn't required for Python 3 although it's in requirements.txt.
  # Because ipaddress doesn't install on Python 3, remove the requirement so the
  # installation of this package doesn't fail on Python 3.
  postPatch = "" + lib.optionalString isPy3k ''
    substituteInPlace requirements.txt --replace "ipaddress>=1.0.16" ""
  '';

  # Skip a failing test until fixed upstream:
  # https://github.com/meejah/txtorcon/issues/250
  checkPhase = ''
    pytest --ignore=test/test_util.py .
  '';

  meta = {
    description = "Twisted-based Tor controller client, with state-tracking and configuration abstractions";
    homepage = https://github.com/meejah/txtorcon;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.mit;
  };
}
