{ lib
<<<<<<< HEAD
, awacs
, buildPythonPackage
, cfn-flip
, fetchFromGitHub
, pythonOlder
, typing-extensions
, unittestCheckHook
=======
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python

  # python dependencies
, awacs
, cfn-flip
, typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "troposphere";
<<<<<<< HEAD
  version = "4.4.1";
=======
  version = "4.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cloudtools";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-ecRpp8XsP/iv4G8m85qcGJXHXH4CPdgBO8c0IZU56wU=";
=======
    hash = "sha256-YciNwiLb/1fUYmlWtDRaJgtkgJi1mMt2FgeJKQi9yRg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cfn-flip
<<<<<<< HEAD
  ] ++ lib.optionals (pythonOlder "3.8") [
=======
  ] ++ lib.lists.optionals (pythonOlder "3.8") [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    typing-extensions
  ];

  nativeCheckInputs = [
    awacs
<<<<<<< HEAD
    unittestCheckHook
  ];

  passthru.optional-dependencies = {
    policy = [
      awacs
    ];
  };

  pythonImportsCheck = [
    "troposphere"
  ];

  meta = with lib; {
    description = "Library to create AWS CloudFormation descriptions";
    homepage = "https://github.com/cloudtools/troposphere";
    changelog = "https://github.com/cloudtools/troposphere/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jlesquembre ];
=======
  ];

  passthru.optional-dependencies = {
    policy = [ awacs ];
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [ "troposphere" ];

  meta = with lib; {
    description = "Library to create AWS CloudFormation descriptions";
    maintainers = with maintainers; [ jlesquembre ];
    license = licenses.bsd2;
    homepage = "https://github.com/cloudtools/troposphere";
    changelog = "https://github.com/cloudtools/troposphere/blob/${version}/CHANGELOG.rst";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
