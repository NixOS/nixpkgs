{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  libmaxminddb,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "maxminddb";
  version = "3.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-sZqTjEgVGPGaLFNP/cs7xZWC8Pu9z5+BrJrfkSoK9oY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ libmaxminddb ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "maxminddb" ];

  # The multiprocessing tests fail on Darwin because multiprocessing uses spawn instead of fork,
  # resulting in an exception when it can’t pickle the `lookup` local function.
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "multiprocessing" ];

  meta = {
    description = "Reader for the MaxMind DB format";
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-python";
    changelog = "https://github.com/maxmind/MaxMind-DB-Reader-python/blob/v${finalAttrs.version}/HISTORY.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
