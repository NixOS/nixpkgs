{lib, buildPythonPackage, fetchPypi, isPy3k, incremental, ipaddress, twisted
, automat, zope_interface, idna, pyopenssl, service-identity, pytest, mock, lsof
, GeoIP}:

buildPythonPackage rec {
  pname = "txtorcon";
  version = "19.0.0";

  checkInputs = [ pytest mock lsof GeoIP ];
  propagatedBuildInputs = [
    incremental twisted automat zope_interface
    # extra dependencies required by twisted[tls]
    idna pyopenssl service-identity
  ] ++ lib.optionals (!isPy3k) [ ipaddress ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "3731b740653e3f551412744f1fcd7fa6f04aa9fa37c90dc6c9152e619886bf3b";
  };

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
