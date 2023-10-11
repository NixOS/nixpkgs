{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, setuptools
, zope_event
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope-lifecycleevent";
  version = "4.4";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.lifecycleevent";
    inherit version;
    hash = "sha256-9ahU6J/5fe6ke/vqN4u77yeJ0uDMkKHB2lfZChzmfLU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ zope_event zope_interface ];

  # namespace colides with local directory
  doCheck = false;

  # zope uses pep 420 namespaces for python3, doesn't work with nix + python2
  pythonImportsCheck = lib.optionals isPy3k [
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
