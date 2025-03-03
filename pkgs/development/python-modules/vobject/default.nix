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
  version = "0.9.8";
  pname = "vobject";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2wCn9NtJOXFV3YpoceiioBdabrpaZUww6RD4KylRS1g=";
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
