{ lib
<<<<<<< HEAD
, argcomplete
, buildPythonPackage
, fetchPypi
, jq
, pytestCheckHook
, pyyaml
, setuptools-scm
, substituteAll
, tomlkit
, xmltodict
=======
, buildPythonPackage
, fetchPypi
, substituteAll
, argcomplete
, pyyaml
, toml
, xmltodict
, jq
, setuptools-scm
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "yq";
<<<<<<< HEAD
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jbt6DJN92/w90XXmR49AlgwUDT6LHxoDFd52OE1mZQo=";
=======
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hT80KxVi3e6XkDjsjs7lQFzdm2p8uB7WzbgBjJ6AJjM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./jq-path.patch;
      jq = "${lib.getBin jq}/bin/jq";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    argcomplete
    pyyaml
    tomlkit
    xmltodict
=======
    pyyaml
    xmltodict
    toml
    argcomplete
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
   pytestCheckHook
  ];

  pytestFlagsArray = [ "test/test.py" ];

  pythonImportsCheck = [ "yq" ];

  meta = with lib; {
    description = "Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents";
    homepage = "https://github.com/kislyuk/yq";
    license = licenses.asl20;
    maintainers = with maintainers; [ womfoo SuperSandro2000 ];
  };
}
