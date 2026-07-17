{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  setuptools-scm,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "variants";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "variants";
    inherit (finalAttrs) version;
    hash = "sha256-UR91tM90g8J+TYbZrM8rUxcmeQDBZtF2Nr7u0RiSm5A=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "variants" ];

  meta = {
    description = "Library providing syntactic sugar for creating variant forms of a canonical function";
    homepage = "https://github.com/python-variants/variants";
    changelog = "https://github.com/python-variants/variants/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
})
