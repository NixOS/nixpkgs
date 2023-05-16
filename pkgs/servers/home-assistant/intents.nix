{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
<<<<<<< HEAD
=======
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# build
, hassil
, jinja2
, pyyaml
, regex
, voluptuous
, python
<<<<<<< HEAD
, setuptools
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# tests
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "home-assistant-intents";
<<<<<<< HEAD
  version = "2023.8.2";
=======
  version = "2023.4.26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant";
<<<<<<< HEAD
    repo = "intents-package";
    rev = "refs/tags/${version}";
    hash = "sha256-pNLH3GGfY8upKi7uYGZ466cIQkpdA16tR1tjwuiQ3JI=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace 'requires = ["setuptools~=62.3", "wheel~=0.37.1"]' 'requires = ["setuptools", "wheel"]'
  '';
=======
    repo = "intents";
    rev = "refs/tags/${version}";
    hash = "sha256-l22+scT/4qIU5qWlWURr5wVEBoWNXGqYEaS3IVwG1Zs=";
  };

  sourceRoot = "source/package";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    hassil
    jinja2
    pyyaml
    regex
    setuptools
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    voluptuous
  ];

  postInstall = ''
<<<<<<< HEAD
    pushd intents
=======
    pushd ..
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # https://github.com/home-assistant/intents/blob/main/script/package#L18
    ${python.pythonForBuild.interpreter} -m script.intentfest merged_output $out/${python.sitePackages}/home_assistant_intents/data
    popd
  '';

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
<<<<<<< HEAD
    "intents/tests"
  ];

  disabledTests = [
    # AssertionError: Recognition failed for 'put apples on the list'
    "test_shopping_list_HassShoppingListAddItem"
=======
    "../tests"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Intents to be used with Home Assistant";
    homepage = "https://github.com/home-assistant/intents";
    license = licenses.cc-by-40;
    maintainers = teams.home-assistant.members;
  };
}
