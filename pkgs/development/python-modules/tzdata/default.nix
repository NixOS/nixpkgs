{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest-subtests,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tzdata";
  version = "2025.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tgpjj8wNr/rfgv4PV+U9Br3sLzbE32YoCuebzmvW8rk=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
  ];

  pythonImportsCheck = [ "tzdata" ];

  meta = {
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
