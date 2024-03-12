{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools
}:

buildPythonPackage rec {
  pname = "home-assistant-intents";
  version = "2024.2.28";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EmnaYc+L1PHOv6M7odYDl+UBZkLJRtP86xPoqdbuOqU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail \
      'requires = ["setuptools~=62.3", "wheel~=0.37.1"]' \
      'requires = ["setuptools"]'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  # sdist does not ship tests
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
