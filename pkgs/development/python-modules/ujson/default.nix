{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "ujson";
  version = "5.12.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-W36WQGwwGhNmU0R5pzUuxA7Gi7MnwMEZCRY1rNWSXjU=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ujson" ];

  meta = {
    description = "Ultra fast JSON encoder and decoder";
    homepage = "https://github.com/ultrajson/ultrajson";
    changelog = "https://github.com/ultrajson/ultrajson/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
