{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, zope-event
, zope-interface
}:

buildPythonPackage rec {
  pname = "zope-lifecycleevent";
  version = "5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.lifecycleevent";
    inherit version;
    hash = "sha256-6tP7SW52FPm1adFtrUt4BSsKwhh1utjWbKNQNS2bb50=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ zope-event zope-interface ];

  # namespace colides with local directory
  doCheck = false;

  pythonImportsCheck = [
    "zope.lifecycleevent"
    "zope.interface"
  ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.lifecycleevent";
    description = "Object life-cycle events";
    changelog = "https://github.com/zopefoundation/zope.lifecycleevent/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}
