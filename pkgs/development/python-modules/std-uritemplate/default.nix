{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "std-uritemplate";
  version = "0.0.54";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "std_uritemplate";
    inherit version;
    hash = "sha256-FVKnB3v/T7eV6IQkaKQ8CFumIMc3PPlAgNOFNohQf9Q=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # Module doesn't have unittest, only functional tests
  doCheck = false;

  pythonImportsCheck = [
    "stduritemplate"
  ];

  meta = with lib; {
    description = "Std-uritemplate implementation for Python";
    homepage = "https://github.com/std-uritemplate/std-uritemplate";
    changelog = "https://github.com/std-uritemplate/std-uritemplate/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
