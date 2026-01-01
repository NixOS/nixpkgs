{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,

  # build-system
  hatchling,
  hatch-vcs,

  # optional-dependencies
<<<<<<< HEAD
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
=======
  brotli,
  brotlicffi,
  pysocks,
  zstandard,

  # tests
  pytestCheckHook,
  pytest-timeout,
  tornado,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  trustme,
}:

let
  self = buildPythonPackage rec {
    pname = "urllib3";
<<<<<<< HEAD
    version = "2.6.0";
=======
    version = "2.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
<<<<<<< HEAD
      hash = "sha256-y5vO9aSzRdXaXRRdw+MINPWOgBiCjLxyTTC0y31NSfE=";
=======
      hash = "sha256-P8R3M8fkGdS8P2s9wrT4kLt0OQajDVa6Slv6S7/5J2A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

    build-system = [
      hatchling
      hatch-vcs
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
<<<<<<< HEAD
        --replace-fail ', "setuptools-scm>=8,<10"' ""
=======
        --replace-fail ', "setuptools-scm>=8,<9"' ""
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    '';

    optional-dependencies = {
      brotli = if isPyPy then [ brotlicffi ] else [ brotli ];
<<<<<<< HEAD
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
=======
      socks = [ pysocks ];
      zstd = [ zstandard ];
    };

    nativeCheckInputs = [
      pytest-timeout
      pytestCheckHook
      tornado
      trustme
    ]
    ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
    meta = {
      description = "Powerful, user-friendly HTTP client for Python";
      homepage = "https://github.com/urllib3/urllib3";
      changelog = "https://github.com/urllib3/urllib3/blob/${version}/CHANGES.rst";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ fab ];
=======
    meta = with lib; {
      description = "Powerful, user-friendly HTTP client for Python";
      homepage = "https://github.com/urllib3/urllib3";
      changelog = "https://github.com/urllib3/urllib3/blob/${version}/CHANGES.rst";
      license = licenses.mit;
      maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };
in
self
