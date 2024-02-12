{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, zope-interface
}:

buildPythonPackage rec {
  pname = "zope-exceptions";
  version = "5.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.exceptions";
    inherit version;
    hash = "sha256-MPxT5TOfX72dEzXg97afd/FePwbisXt/t++SXMJP3ZY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ zope-interface ];

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
