<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
=======
{ buildPythonPackage
, fetchFromGitHub
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mbstrdecoder
, python-dateutil
, pytz
, packaging
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, tcolorpy
}:

buildPythonPackage rec {
  pname = "typepy";
<<<<<<< HEAD
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-cgy1+6RZ1DUyH45bAKpGPOOZCwhCUghummw2fnfJGww=";
  };

  propagatedBuildInputs = [
    mbstrdecoder
  ];

  passthru.optional-dependencies = {
    datetime = [
      python-dateutil
      pytz
      packaging
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    tcolorpy
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "typepy"
  ];

  meta = with lib; {
    description = "Library for variable type checker/validator/converter at a run time";
    homepage = "https://github.com/thombashi/typepy";
    changelog = "https://github.com/thombashi/typepy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ genericnerdyusername ];
=======
    rev = "v${version}";
    hash = "sha256-J6SgVd2m0wOVr2ZV/pryRcJrn+BYTGstAUQO349c2lE=";
  };

  propagatedBuildInputs = [ mbstrdecoder python-dateutil pytz packaging ];

  nativeCheckInputs = [ pytestCheckHook ];
  checkInputs = [ tcolorpy ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/typepy";
    description = "A library for variable type checker/validator/converter at a run time";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
