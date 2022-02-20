{ lib, stdenv, python, buildPythonPackage, pythonOlder, fetchPypi, isPy3k, incremental, ipaddress, twisted
, automat, zope_interface, idna, pyopenssl, service-identity, pytest, mock, lsof
, GeoIP}:

buildPythonPackage rec {
  pname = "txtorcon";
  version = "21.1.0";

  checkInputs = [ pytest mock lsof GeoIP ];
  propagatedBuildInputs = [
    incremental twisted automat zope_interface
    # extra dependencies required by twisted[tls]
    idna pyopenssl service-identity
  ] ++ lib.optionals (!isPy3k) [ ipaddress ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "aebf0b9ec6c69a029f6b61fd534e785692e28fdcd2fd003ce3cc132b9393b7d6";
  };

  # Based on what txtorcon tox.ini will automatically test, allow back as far
  # as Python 3.5.
  disabled = pythonOlder "3.5";

  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);
  checkPhase = ''
    ${python.interpreter} -m twisted.trial -j $NIX_BUILD_CORES ./test
  '';

  meta = {
    description = "Twisted-based Tor controller client, with state-tracking and configuration abstractions";
    homepage = "https://github.com/meejah/txtorcon";
    maintainers = with lib.maintainers; [ jluttine exarkun ];
    license = lib.licenses.mit;
  };
}
