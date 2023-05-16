{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, zope-i18nmessageid
=======
, zope_i18nmessageid
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope.size";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bhv3QJdZtNpyAuL6/aZXWD1Acx8661VweWaItJPpkHk=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [ zope-i18nmessageid zope_interface ];
=======
  propagatedBuildInputs = [ zope_i18nmessageid zope_interface ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.size";
    description = "Interfaces and simple adapter that give the size of an object";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
