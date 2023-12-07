{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, zope_event
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "5.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v+4fP/YhQ4GUmeNI9bin86oCWfmspeDdrnOR0Fnc5nE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    zope_event
  ];

  # Circular dependency
  doCheck = false;

  pythonImportsCheck = [
    "zope.interface"
  ];

  meta = with lib; {
    description = "Zope.Interface";
    homepage = "https://github.com/zopefoundation/zope.interface";
    changelog = "https://github.com/zopefoundation/zope.interface/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
