{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, setuptools

# codegen
, hassil
, python
, pyyaml
, voluptuous
, regex
, jinja2

# tests
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "home-assistant-intents";
  version = "2024.8.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "intents-package";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-s6cw9Ni4NFNNLu7s8YaHk6MeKlss60GgxdwcUVA1djo=";
  };

  build-system = [
    setuptools

    # build-time codegen; https://github.com/home-assistant/intents/blob/main/requirements.txt#L1-L5
    hassil
    pyyaml
    voluptuous
    regex
    jinja2
  ];

  postInstall = ''
    # https://github.com/home-assistant/intents-package/blob/main/script/package#L23-L24
    PACKAGE_DIR=$out/${python.sitePackages}/home_assistant_intents
    ${python.pythonOnBuildForHost.interpreter} script/merged_output.py $PACKAGE_DIR/data
    ${python.pythonOnBuildForHost.interpreter} script/write_languages.py $PACKAGE_DIR/data > $PACKAGE_DIR/languages.py
  '';

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "intents/tests"
  ];

  meta = with lib; {
    description = "Intents to be used with Home Assistant";
    homepage = "https://github.com/home-assistant/intents";
    license = licenses.cc-by-40;
    maintainers = teams.home-assistant.members;
  };
}
