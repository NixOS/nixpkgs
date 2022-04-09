{ lib, stdenv, python, buildPythonPackage, pythonOlder, fetchPypi, isPy3k, incremental, ipaddress, twisted
, automat, zope_interface, idna, pyopenssl, service-identity, pytest, mock, lsof
, GeoIP}:

buildPythonPackage rec {
  pname = "txtorcon";
  version = "22.0.0";

  checkInputs = [ pytest mock lsof GeoIP ];
  propagatedBuildInputs = [
    incremental twisted automat zope_interface
    # extra dependencies required by twisted[tls]
    idna pyopenssl service-identity
  ] ++ lib.optionals (!isPy3k) [ ipaddress ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iaG2XjKks2nWfmwWY4f7xGjMXQUidEjSOaXn6XGKoFM=";
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
