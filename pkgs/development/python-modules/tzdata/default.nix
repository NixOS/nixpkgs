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
  version = "2025.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tgpjj8wNr/rfgv4PV+U9Br3sLzbE32YoCuebzmvW8rk=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
  ]
  ++ lib.optionals (pythonOlder "3.7") [ importlib-resources ];

  pythonImportsCheck = [ "tzdata" ];

  meta = with lib; {
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
