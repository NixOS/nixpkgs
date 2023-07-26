{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
, hassil
, jinja2
, pyyaml
, regex
, voluptuous
, python
, setuptools
, wheel

# tests
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "home-assistant-intents";
  version = "2023.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "intents-package";
    rev = "refs/tags/${version}";
    hash = "sha256-pNLH3GGfY8upKi7uYGZ466cIQkpdA16tR1tjwuiQ3JI=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace 'requires = ["setuptools~=62.3", "wheel~=0.37.1"]' 'requires = ["setuptools", "wheel"]'
  '';

  nativeBuildInputs = [
    hassil
    jinja2
    pyyaml
    regex
    setuptools
    wheel
    voluptuous
  ];

  postInstall = ''
    pushd intents
    # https://github.com/home-assistant/intents/blob/main/script/package#L18
    ${python.pythonForBuild.interpreter} -m script.intentfest merged_output $out/${python.sitePackages}/home_assistant_intents/data
    popd
  '';

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "intents/tests"
  ];

  disabledTests = [
    # AssertionError: Recognition failed for 'put apples on the list'
    "test_shopping_list_HassShoppingListAddItem"
  ];

  meta = with lib; {
    description = "Intents to be used with Home Assistant";
    homepage = "https://github.com/home-assistant/intents";
    license = licenses.cc-by-40;
    maintainers = teams.home-assistant.members;
  };
}
