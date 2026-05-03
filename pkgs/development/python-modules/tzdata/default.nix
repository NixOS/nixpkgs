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
  version = "2026.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kXP959gNkBjgKmYuFo5aLQT4fEHqF0sTn772Qu2mLRA=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
  ]
  ++ lib.optionals (pythonOlder "3.7") [ importlib-resources ];

  pythonImportsCheck = [ "tzdata" ];

  meta = {
    changelog = "https://github.com/python/tzdata/blob/${version}/NEWS.md";
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
