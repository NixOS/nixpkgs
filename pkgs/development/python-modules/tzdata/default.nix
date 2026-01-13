{
  lib,
  buildPythonPackage,
  fetchPypi,
  importlib-resources,
  pytest-subtests,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tzdata";
  version = "2025.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3jnCyl3HsDRPLrqG9J1hQBnSnwYPxOvIpBeJamILVqc=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
  ]
  ++ lib.optionals (pythonOlder "3.7") [ importlib-resources ];

  pythonImportsCheck = [ "tzdata" ];

  meta = {
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
