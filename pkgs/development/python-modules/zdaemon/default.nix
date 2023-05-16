{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, zconfig
}:

buildPythonPackage rec {
  pname = "zdaemon";
<<<<<<< HEAD
  version = "5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ml7GxRmigLvPqPfnP04Q2AjnuCcQq2COD0Sb88BtQ9U=";
=======
  version = "4.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SCHjvbRzh88eklWwREusQ3z3KqC1nRQHuTLjH9QyPvw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    zconfig
  ];

  # too many deps..
  doCheck = false;

  pythonImportsCheck = [
    "zdaemon"
  ];

  meta = with lib; {
    description = "A daemon process control library and tools for Unix-based systems";
    homepage = "https://pypi.python.org/pypi/zdaemon";
    changelog = "https://github.com/zopefoundation/zdaemon/blob/${version}/CHANGES.rst";
<<<<<<< HEAD
    license = licenses.zpl21;
=======
    license = licenses.zpl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ goibhniu ];
  };
}
