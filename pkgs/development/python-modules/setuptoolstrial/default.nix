{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
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
=======
, pytest
, virtualenv
, pytest-runner
, pytest-virtualenv
, twisted
, pathlib2
}:

buildPythonPackage rec {
  pname = "setuptools_trial";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14220f8f761c48ba1e2526f087195077cf54fad7098b382ce220422f0ff59b12";
  };

  buildInputs = [ pytest virtualenv pytest-runner pytest-virtualenv ];
  propagatedBuildInputs = [ twisted pathlib2 ];

  postPatch = ''
    sed -i '12,$d' tests/test_main.py
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Couldn't get tests working
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "setuptools_trial"
  ];

  meta = with lib; {
    description = "Setuptools plugin that makes unit tests execute with trial instead of pyunit";
=======
  meta = with lib; {
    description = "Setuptools plugin that makes unit tests execute with trial instead of pyunit.";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/rutsky/setuptools-trial";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ryansydnor ];
  };
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
