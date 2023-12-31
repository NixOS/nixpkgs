{ lib
, brotli
, brotlicffi
, buildPythonPackage
, certifi
, cryptography
, fetchpatch
, fetchPypi
, idna
, isPyPy
, mock
, pyopenssl
, pysocks
, pytest-freezegun
, pytest-timeout
, pytestCheckHook
, python-dateutil
, tornado
, trustme
}:

buildPythonPackage rec {
  pname = "urllib3";
  version = "1.26.18";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+OzBu6VmdBNFfFKauVW/jGe0XbeZ0VkGYmFxnjKFgKA=";
  };

  patches = [
    (fetchpatch {
      name = "revert-threadsafe-poolmanager.patch";
      url = "https://github.com/urllib3/urllib3/commit/710114d7810558fd7e224054a566b53bb8601494.patch";
      revert = true;
      hash = "sha256-2O0y0Tij1QF4Hx5r+WMxIHDpXTBHign61AXLzsScrGo=";
    })
  ];

  # FIXME: remove backwards compatbility hack
  propagatedBuildInputs = passthru.optional-dependencies.brotli
    ++ passthru.optional-dependencies.socks;

  nativeCheckInputs = [
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

  pythonImportsCheck = [
    "urllib3"
  ];

  passthru.optional-dependencies = {
    brotli = if isPyPy then [
      brotlicffi
    ] else [
      brotli
    ];
    # Use carefully since pyopenssl is not supported aarch64-darwin
    secure = [
      certifi
      cryptography
      idna
      pyopenssl
    ];
    socks = [
      pysocks
    ];
  };

  meta = with lib; {
    description = "Powerful, sanity-friendly HTTP client for Python";
    homepage = "https://github.com/shazow/urllib3";
    changelog = "https://github.com/urllib3/urllib3/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
