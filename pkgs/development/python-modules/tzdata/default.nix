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
  version = "2025.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JIlJCeiM2yi9FjbGiHgB32TLSFvVk/L9g+8pB1qB1pQ=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
  ] ++ lib.optionals (pythonOlder "3.7") [ importlib-resources ];

  pythonImportsCheck = [ "tzdata" ];

  meta = with lib; {
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
