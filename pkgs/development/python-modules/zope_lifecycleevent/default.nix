{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, zope_event
<<<<<<< HEAD
, zope-component
=======
, zope_component
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "zope.lifecycleevent";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9ahU6J/5fe6ke/vqN4u77yeJ0uDMkKHB2lfZChzmfLU=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [ zope_event zope-component ];
=======
  propagatedBuildInputs = [ zope_event zope_component ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
