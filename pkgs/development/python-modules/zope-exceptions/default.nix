{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope-exceptions";
  version = "4.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.exceptions";
    inherit version;
    hash = "sha256-YZ0kpMZb7Zez3QUV5zLoK2nxVdQsyUlV0b6MKCiGg80=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ zope_interface ];

  # circular deps
  doCheck = false;

  pythonImportsCheck = [
    "zope.exceptions"
  ];

  meta = with lib; {
    description = "Exception interfaces and implementations";
    homepage = "https://pypi.python.org/pypi/zope.exceptions";
    changelog = "https://github.com/zopefoundation/zope.exceptions/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };

}
