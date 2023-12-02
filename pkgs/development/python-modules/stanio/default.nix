{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, numpy
}:

buildPythonPackage rec {
  pname = "stanio";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i1hqwUs1zeGq0Yjb+FgkUVxoQtyVGitBHdE4+1w1/J8=";
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
