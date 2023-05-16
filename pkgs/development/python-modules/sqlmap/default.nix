{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, file
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sqlmap";
<<<<<<< HEAD
  version = "1.7.9";
=======
  version = "1.7.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-k07Dpkpa1MO9ICMl4a2YI2ONgcUG0vLOzC+wsoHxI3s=";
=======
    hash = "sha256-PQk3uEY1gjvs5BerfEAEZe4v6uZYpCZqCo+Qc7mSUw8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace sqlmap/thirdparty/magic/magic.py --replace "ctypes.util.find_library('magic')" \
      "'${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"

    # the check for the last update date does not work in Nix,
    # since the timestamp of the all files in the nix store is reset to the unix epoch
    echo 'LAST_UPDATE_NAGGING_DAYS = float("inf")' >> sqlmap/lib/core/settings.py
  '';

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [
    "sqlmap"
  ];

  meta = with lib; {
    description = "Automatic SQL injection and database takeover tool";
    homepage = "https://sqlmap.org";
    changelog = "https://github.com/sqlmapproject/sqlmap/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bennofs ];
  };
}
