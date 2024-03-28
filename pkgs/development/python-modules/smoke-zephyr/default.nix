{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "smoke-zephyr";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4JBueNYL3OML+7+k+CJuhlL+xzRZwTEP9G/0/aI0aek=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "smoke_zephyr" ];

  meta = with lib; {
    description = "This project provides a collection of miscellaneous Python utilities";
    homepage = "https://pypi.org/project/smoke-zephyr/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
