{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools

# build
, hassil
, jinja2
, pyyaml
, regex
, voluptuous
, python

# tests
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "home-assistant-intents";
  version = "2023.6.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "intents";
    rev = "refs/tags/${version}";
    hash = "sha256-ZfPOxTFPQNdZ3Tq8p410RHlLGej+FOqhafD+91MRbRo=";
  };

  sourceRoot = "source/package";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "2023.4.26" "${version}"
  '';

  nativeBuildInputs = [
    hassil
    jinja2
    pyyaml
    regex
    setuptools
    voluptuous
  ];

  postInstall = ''
    pushd ..
    # https://github.com/home-assistant/intents/blob/main/script/package#L18
    ${python.pythonForBuild.interpreter} -m script.intentfest merged_output $out/${python.sitePackages}/home_assistant_intents/data
    popd
  '';

  checkInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "../tests"
  ];

  meta = with lib; {
    description = "Intents to be used with Home Assistant";
    homepage = "https://github.com/home-assistant/intents";
    license = licenses.cc-by-40;
    maintainers = teams.home-assistant.members;
  };
}
