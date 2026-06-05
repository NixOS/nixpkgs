{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tzdata";
  version = "2026.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kXP959gNkBjgKmYuFo5aLQT4fEHqF0sTn772Qu2mLRA=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tzdata" ];

  meta = {
    changelog = "https://github.com/python/tzdata/blob/${version}/NEWS.md";
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
