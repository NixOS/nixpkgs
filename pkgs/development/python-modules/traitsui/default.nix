{ lib
, fetchPypi
, buildPythonPackage
, traits
, pyface
, pythonOlder
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "7.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JTNa/+4jQtR+NcJd9ed4XSKlM1hP4b4JQ8y6Rdwa5Yk=";
  };

  propagatedBuildInputs = [
    traits
    pyface
  ];

  # Needs X server
  doCheck = false;

  pythonImportsCheck = [
    "traitsui"
  ];

  meta = with lib; {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/traitsui";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
