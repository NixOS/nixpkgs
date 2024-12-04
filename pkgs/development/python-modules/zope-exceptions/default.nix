{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope-exceptions";
  version = "5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.exceptions";
    inherit version;
    hash = "sha256-TLoySGeHc7usb6o641N98JqEOIG4n7noGsooLzuSsvM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ zope-interface ];

  # circular deps
  doCheck = false;

  pythonImportsCheck = [ "zope.exceptions" ];

  meta = with lib; {
    description = "Exception interfaces and implementations";
    homepage = "https://pypi.python.org/pypi/zope.exceptions";
    changelog = "https://github.com/zopefoundation/zope.exceptions/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = [ ];
  };
}
