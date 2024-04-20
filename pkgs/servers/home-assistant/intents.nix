{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools
}:

buildPythonPackage rec {
  pname = "home-assistant-intents";
  version = "2024.4.3";
  format = "wheel";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version format;
    pname = "home_assistant_intents";
    dist = "py3";
    python = "py3";
    hash = "sha256-GraYVtioKIoKlPRBhhhzlbBfI6heXAaA1MQpUqAgEDQ=";
  };

  build-system = [
    setuptools
  ];

  # sdist/wheel do not ship tests
  doCheck = false;

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
