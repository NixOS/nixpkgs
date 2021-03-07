{ lib
, brotli
, buildPythonPackage
, certifi
, cryptography
, dateutil
, fetchPypi
, idna
, mock
, pyopenssl
, pysocks
, pytest-freezegun
, pytest-timeout
, pytestCheckHook
, pythonOlder
, tornado
, trustme
}:

buildPythonPackage rec {
  pname = "urllib3";
  version = "1.26.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73";
  };

  propagatedBuildInputs = [
    brotli
    certifi
    cryptography
    idna
    pyopenssl
    pysocks
  ];

  checkInputs = [
    dateutil
    mock
    pytest-freezegun
    pytest-timeout
    pytestCheckHook
    tornado
    trustme
  ];

  disabledTests = [
    # socket.timeout: _ssl.c:1108: The handshake operation timed out
    "test_ssl_custom_validation_failure_terminates"
  ];

  pythonImportsCheck = [ "urllib3" ];

  meta = with lib; {
    description = "Powerful, sanity-friendly HTTP client for Python";
    homepage = "https://github.com/shazow/urllib3";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
