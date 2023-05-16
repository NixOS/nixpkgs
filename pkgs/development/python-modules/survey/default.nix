{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
<<<<<<< HEAD
, setuptools-scm
=======
, wrapio
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "survey";
<<<<<<< HEAD
  version = "4.5.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wjpO1+9AXi75uPXOTE5/owEiZgtffkkMAaZ+gDO0t5I=";
  };

  nativeBuildInputs = [
    setuptools-scm
=======
  version = "3.4.3";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TK89quY3bpNIEz1n3Ecew4FnTH6QgeSLdDNV86gq7+I=";
  };

  propagatedBuildInputs = [
    wrapio
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = false;
  pythonImportsCheck = [ "survey" ];

  meta = with lib; {
    description = "A simple library for creating beautiful interactive prompts";
    homepage = "https://github.com/Exahilosys/survey";
    changelog = "https://github.com/Exahilosys/survey/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
