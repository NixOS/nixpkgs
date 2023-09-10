{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, twisted
}:

buildPythonPackage rec {
  pname = "setuptools-trial";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "setuptools_trial";
    inherit version;
    hash = "sha256-FCIPj3YcSLoeJSbwhxlQd89U+tcJizgs4iBCLw/1mxI=";
  };

  propagatedBuildInputs = [
    twisted
  ];

  # Couldn't get tests working
  doCheck = false;

  pythonImportsCheck = [
    "setuptools_trial"
  ];

  meta = with lib; {
    description = "Setuptools plugin that makes unit tests execute with trial instead of pyunit";
    homepage = "https://github.com/rutsky/setuptools-trial";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
