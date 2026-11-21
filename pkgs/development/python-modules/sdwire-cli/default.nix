{
  lib,
  adafruit-board-toolkit,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  poetry-core,
  pyftdi,
  pyudev,
  pyusb,
  pythonOlder,
  semver,
  ...
}@args:

buildPythonPackage rec {
  pname = "sdwire";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Badger-Embedded";
    repo = "sdwire-cli";
    rev = "0.2.3";
    hash = "sha256-xsNKBOpJAtS02++dEfKZ2fVYDie6ycr9Xm9FO4uedMk=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    adafruit-board-toolkit
    click
    pyftdi
    pyudev
    pyusb
    semver
  ];

  pythonRelaxDeps = [ "pyftdi" ];

  pythonImportsCheck = [ "sdwire" ];

  meta = with lib; {
    description = "CLI for Badgerd SDWire Devices";
    homepage = "https://github.com/Badger-Embedded/sdwire-cli";
    changelog = "https://github.com/Badger-Embedded/sdwire-cli/releases/tag/${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ watwea ];
  };
}
