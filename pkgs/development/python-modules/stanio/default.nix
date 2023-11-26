{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, numpy
}:

buildPythonPackage rec {
  pname = "stanio";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DFBK5nG41Sah2nEYWsAqJ3VQj/5tPbkfJC6shbz2BG8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "stanio" ];

  meta = with lib; {
    description = "Preparing inputs to and reading outputs from Stan";
    homepage = "https://github.com/WardBrian/stanio";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
  };
}
