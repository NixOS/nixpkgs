{ lib
, buildPythonPackage
, coverage
, fetchPypi
, isPy27
, pytest-cov
, pytestCheckHook
, toml
}:

buildPythonPackage rec {
  pname = "vulture";
  version = "2.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ryrmsm72z3fzaanyblz49q40h9d3bbl4pspn2lvkkp9rcmsdm83";
  };

  propagatedBuildInputs = [ toml ];

  checkInputs = [
    coverage
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "vulture" ];

  meta = with lib; {
    description = "Finds unused code in Python programs";
    homepage = "https://github.com/jendrikseipp/vulture";
    license = licenses.mit;
    maintainers = with maintainers; [ mcwitt ];
  };
}
