{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  setuptools,
  python-dateutil,
  pytz,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vobject";
  version = "0.9.9";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "py-vobject";
    repo = "vobject";
    tag = "v${version}";
    hash = "sha256-OL0agVpV/kWph6KhpzDhfzayscs0OaJ2W9WIilXVaS0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    pytz
    six
  ];

  pythonImportsCheck = [ "vobject" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests.py" ];

  meta = with lib; {
    description = "Module for reading vCard and vCalendar files";
    homepage = "https://github.com/py-vobject/vobject";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
