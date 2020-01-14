{lib, buildPythonPackage, fetchPypi, isPy3k, incremental, ipaddress, twisted
, automat, zope_interface, idna, pyopenssl, service-identity, pytest, mock, lsof
, GeoIP, isPy27}:

buildPythonPackage rec {
  pname = "txtorcon";
  version = "19.1.0";

  checkInputs = [ pytest mock lsof GeoIP ];
  propagatedBuildInputs = [
    incremental twisted automat zope_interface
    # extra dependencies required by twisted[tls]
    idna pyopenssl service-identity
  ] ++ lib.optionals (!isPy3k) [ ipaddress ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "19ayn5w9ayxbb1m84l1s9qlb6kv7sz6sg34mzy8bnidc7qnfbn15";
  };

  # zope.interface issue
  doCheck = isPy3k;
  # Skip a failing test until fixed upstream:
  # https://github.com/meejah/txtorcon/issues/250
  checkPhase = ''
    pytest --ignore=test/test_util.py .
  '';

  meta = {
    description = "Twisted-based Tor controller client, with state-tracking and configuration abstractions";
    homepage = https://github.com/meejah/txtorcon;
    maintainers = with lib.maintainers; [ jluttine ];
    # Currently broken on Python 2.7. See
    # https://github.com/NixOS/nixpkgs/issues/71826
    broken = isPy27;
    license = lib.licenses.mit;
  };
}
