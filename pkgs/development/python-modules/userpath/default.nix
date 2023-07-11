{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, click
, pythonOlder
}:

buildPythonPackage rec {
  pname = "userpath";
  version = "1.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BCM9L8/lz/kRweT7cYl1VkDhUk/4ekuCq51rh1/uV4c=";
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
