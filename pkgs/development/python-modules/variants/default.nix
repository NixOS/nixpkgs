{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "variants";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UR91tM90g8J+TYbZrM8rUxcmeQDBZtF2Nr7u0RiSm5A=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "variants" ];

  meta = {
    description = "Library providing syntactic sugar for creating variant forms of a canonical function";
    homepage = "https://github.com/python-variants/variants";
    changelog = "https://github.com/python-variants/variants/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
}
