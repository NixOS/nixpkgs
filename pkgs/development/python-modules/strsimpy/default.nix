{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "strsimpy";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-CELrV/evhsiCpZobyHIewlgKJn5WP9BQPO0pcgQDcsk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # uses unittest assertion aliases removed in python 3.12
  disabledTests = [ "testSIFT4" ];

  pythonImportsCheck = [ "strsimpy" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "String similarity and distance measures library";
    homepage = "https://github.com/luozhouyang/python-string-similarity";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ denzonl ];
  };
})
