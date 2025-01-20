{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  setuptools,
  python-dateutil,
  pytz,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "0.9.9";
  pname = "vobject";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rETl1+IHnYTB1SxQphW5vsSxupWGCMTH/kDL8zJHs44=";
  };

  disabled = isPyPy;

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    pytz
    six
  ];

  pythonImportsCheck = [ "vobject" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  meta = with lib; {
    description = "Module for reading vCard and vCalendar files";
    homepage = "https://github.com/py-vobject/vobject";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
