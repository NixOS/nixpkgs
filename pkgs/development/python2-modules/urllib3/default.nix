{ lib
, brotli
, buildPythonPackage
, certifi
, cryptography
, python-dateutil
, fetchpatch
, fetchPypi
, idna
, mock
, pyopenssl
, pysocks
, pytest-freezegun
, pytest-timeout
, pytestCheckHook
, tornado
, trustme
}:

buildPythonPackage rec {
  pname = "urllib3";
  version = "1.26.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-28363.patch";
      url = "https://github.com/urllib3/urllib3/commit/8d65ea1ecf6e2cdc27d42124e587c1b83a3118b0.patch";
      sha256 = "1lqhrd11p03iv14bp89rh67ynf000swmwsfvr3jpfdycdqr3ka9q";
    })
  ];

  propagatedBuildInputs = [
    brotli
    certifi
    cryptography
    idna
    pyopenssl
    pysocks
  ];

  checkInputs = [
    python-dateutil
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
