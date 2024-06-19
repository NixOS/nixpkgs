{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,

  # build-system
  hatchling,

  # optional-dependencies
  brotli,
  brotlicffi,
  pysocks,

  # tests
  backports-zoneinfo,
  pytestCheckHook,
  pytest-timeout,
  pythonOlder,
  tornado,
  trustme,
}:

let
  self = buildPythonPackage rec {
    pname = "urllib3";
    version = "2.2.1";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-0FcIdsYaueUg13bDisu7WwWndtP5/5ilyP1RYqREzxk=";
    };

    nativeBuildInputs = [ hatchling ];

    passthru.optional-dependencies = {
      brotli = if isPyPy then [ brotlicffi ] else [ brotli ];
      socks = [ pysocks ];
    };

    nativeCheckInputs =
      [
        pytest-timeout
        pytestCheckHook
        tornado
        trustme
      ]
      ++ lib.optionals (pythonOlder "3.9") [ backports-zoneinfo ]
      ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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

    meta = with lib; {
      description = "Powerful, user-friendly HTTP client for Python";
      homepage = "https://github.com/urllib3/urllib3";
      changelog = "https://github.com/urllib3/urllib3/blob/${version}/CHANGES.rst";
      license = licenses.mit;
      maintainers = with maintainers; [ fab ];
    };
  };
in
self
