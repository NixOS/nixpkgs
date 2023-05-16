<<<<<<< HEAD
{ lib
, buildPythonPackage
, colorama
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, regex
=======
{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, colorama, regex
, pytest-runner, pytestCheckHook, pytest-mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "tatsu";
  version = "5.8.3";
<<<<<<< HEAD
  format = "setuptools";

=======
  # upstream only supports 3.10+
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "neogeny";
    repo = "TatSu";
    rev = "refs/tags/v${version}";
    hash = "sha256-cKEMRbH/xNtYM0lmNVazv3i0Q1tmVrVPrB6F2s02Sro=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [
    colorama
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tatsu"
  ];
=======
  nativeBuildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ colorama regex ];
  nativeCheckInputs = [ pytestCheckHook pytest-mypy ];

  pythonImportsCheck = [ "tatsu" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Generates Python parsers from grammars in a variation of EBNF";
    longDescription = ''
      TatSu (the successor to Grako) is a tool that takes grammars in a
      variation of EBNF as input, and outputs memoizing (Packrat) PEG parsers in
      Python.
    '';
    homepage = "https://tatsu.readthedocs.io/";
<<<<<<< HEAD
    changelog = "https://github.com/neogeny/TatSu/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
=======
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
