{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,

  # build-system
  hatchling,
  hatch-vcs,

  # optional-dependencies
  backports-zstd,
  brotli,
  brotlicffi,
  h2,
  pysocks,

  # tests
  httpx,
  pyopenssl,
  pytestCheckHook,
  pytest-socket,
  pytest-timeout,
  quart,
  quart-trio,
  tornado,
  trio,
  trustme,
}:

let
  self = buildPythonPackage rec {
    pname = "urllib3";
    version = "2.6.0";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-y5vO9aSzRdXaXRRdw+MINPWOgBiCjLxyTTC0y31NSfE=";
    };

    build-system = [
      hatchling
      hatch-vcs
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail ', "setuptools-scm>=8,<10"' ""
    '';

    optional-dependencies = {
      brotli = if isPyPy then [ brotlicffi ] else [ brotli ];
      h2 = [ h2 ];
      socks = [ pysocks ];
      zstd = [ backports-zstd ];
    };

    nativeCheckInputs = [
      httpx
      pyopenssl
      pytest-socket
      pytest-timeout
      pytestCheckHook
      quart
      quart-trio
      tornado
      trio
      trustme
    ]
    ++ lib.concatAttrValues optional-dependencies;

    disabledTestMarks = [
      "requires_network"
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

    passthru.tests.pytest = self.overridePythonAttrs (_: {
      doCheck = true;
    });

    preCheck = ''
      export CI # Increases LONG_TIMEOUT
    '';

    pythonImportsCheck = [ "urllib3" ];

    meta = {
      description = "Powerful, user-friendly HTTP client for Python";
      homepage = "https://github.com/urllib3/urllib3";
      changelog = "https://github.com/urllib3/urllib3/blob/${version}/CHANGES.rst";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ fab ];
    };
  };
in
self
