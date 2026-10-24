{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "toolrack";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-BtLDgnv1iso0ZwxbGy1rlHh/DFqcfazY11ixElKjvE4=";
  };

  build-system = [ setuptools ];

  dependencies = [ pytest ];

  pythonImportsCheck = [ "toolrack.script" ];

  meta = {
    description = "Collection of miscellaneous utility functions and classes";
    homepage = "https://github.com/albertodonato/toolrack";
    changelog = "https://github.com/albertodonato/toolrack/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ jeanralphaviles ];
  };
})
