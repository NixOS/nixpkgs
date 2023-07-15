{ lib
, stdenv
, automat
, buildPythonPackage
, cryptography
, fetchPypi
, geoip
, idna
, incremental
, lsof
, mock
, pyopenssl
, pytestCheckHook
, python
, pythonOlder
, service-identity
, twisted
, zope_interface
}:

buildPythonPackage rec {
  pname = "txtorcon";
  version = "23.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k/2Aqd1QX2mNCGT+k9uLapwRRLX+uRUwggtw7YmCZRw=";
  };

  propagatedBuildInputs = [
    cryptography
    incremental
    twisted
    automat
    zope_interface
  ] ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    pytestCheckHook
    mock
    lsof
    geoip
  ];

  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  meta = with lib; {
    description = "Twisted-based Tor controller client, with state-tracking and configuration abstractions";
    homepage = "https://github.com/meejah/txtorcon";
    changelog = "https://github.com/meejah/txtorcon/releases/tag/v${version}";
    maintainers = with maintainers; [ jluttine exarkun ];
    license = licenses.mit;
  };
}
