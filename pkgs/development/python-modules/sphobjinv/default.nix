{
  lib,
  attrs,
  buildPythonPackage,
  certifi,
  dictdiffer,
  fetchPypi,
  jsonschema,
  pytest-check,
  pytest-retry,
  pytest-timeout,
  pythonOlder,
  setuptools,
  sphinx,
  stdio-mgr,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphobjinv";
  version = "2.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-RNV+fofhfYx7BTyFPcw2+Ay/fR/BUtV2NP17yuOMpIo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    certifi
    jsonschema
  ];

  # Network-dependent tests self-skip without the --nonloc flag.
  nativeCheckInputs = [
    pytestCheckHook
    dictdiffer
    pytest-check
    pytest-retry
    pytest-timeout
    sphinx
    stdio-mgr
  ];

  # The CLI tests invoke the installed console scripts, which are not on
  # PATH when tests run.
  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [ "sphobjinv" ];

  meta = {
    description = "Sphinx objects.inv Inspection/Manipulation Tool";
    homepage = "https://github.com/bskinn/sphobjinv";
    changelog = "https://github.com/bskinn/sphobjinv/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
    mainProgram = "sphobjinv";
  };
})
