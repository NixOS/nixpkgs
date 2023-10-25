{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, click
, pythonOlder
}:

buildPythonPackage rec {
  pname = "userpath";
  version = "1.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-heMnRUMXRHfGLVcB7UOj7xBRgkqd13aWitxBHlhkDdE=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    click
  ];

  # Test suite is difficult to emulate in sandbox due to shell manipulation
  doCheck = false;

  pythonImportsCheck = [
    "userpath"
  ];

  meta = with lib; {
    description = "Cross-platform tool for adding locations to the user PATH";
    homepage = "https://github.com/ofek/userpath";
    changelog = "https://github.com/ofek/userpath/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ yshym ];
  };
}
