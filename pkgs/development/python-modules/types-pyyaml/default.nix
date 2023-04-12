{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pyyaml";
  version = "6.0.12.8";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-PyYAML";
    inherit version;
    hash = "sha256-GTBIaaidSa8AvmgeeyZ0FN8hP064ljTESV+mLo+UK58=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "yaml-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for PyYAML";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnr ];
  };
}
