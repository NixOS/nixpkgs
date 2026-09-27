{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sumtypes";
  version = "0.1a6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "radix";
    repo = "sumtypes";
    tag = finalAttrs.version;
    hash = "sha256-qwQyFKVnGEqHUqFmUSnHVvedsp2peM6rJZcS90paLOo=";
  };

  build-system = [ setuptools ];

  dependencies = [ attrs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sumtypes" ];

  meta = {
    description = "Algebraic data types for Python";
    homepage = "https://github.com/radix/sumtypes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NieDzejkob ];
  };
})
