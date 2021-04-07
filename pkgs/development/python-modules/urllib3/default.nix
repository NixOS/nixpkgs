{ lib
, brotli
, buildPythonPackage
, cryptography
, dateutil
, fetchPypi
, idna
, isPy27
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

  src = fetchPypi {
    inherit pname version;
    sha256 = "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73";
  };

  propagatedBuildInputs = [
    brotli
    pysocks
  ] ++ lib.optionals isPy27 [
    cryptography
    idna
    pyopenssl
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

  # Tests in urllib3 are mostly timeout-based instead of event-based and
  # are therefore inherently flaky. On your own machine, the tests will
  # typically build fine, but on a loaded cluster such as Hydra random
  # timeouts will occur.
  #
  # The urllib3 test suite has two different timeouts in their test suite
  # (see `test/__init__.py`):
  # - SHORT_TIMEOUT
  # - LONG_TIMEOUT
  # When CI is in the env, LONG_TIMEOUT will be significantly increased.
  # Still, failures can occur and for that reason tests are disabled.
  doCheck = false;

  preCheck = ''
    export CI # Increases LONG_TIMEOUT
  '';

  pythonImportsCheck = [ "urllib3" ];

  meta = with lib; {
    description = "Powerful, sanity-friendly HTTP client for Python";
    homepage = "https://github.com/shazow/urllib3";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
