{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqids";
  version = "0.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-WsCPDFybaBS8Lnx57lkx4ISdJdlcUOQVdxsCKkT1ivk=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqids" ];

  meta = {
    homepage = "https://sqids.org/python";
    description = "Library that lets you generate short YouTube-looking IDs from numbers";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ panicgh ];
  };
})
