{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, nose
, mock
, six
, isPyPy
, pythonOlder
=======
, rednose
, six
, mock
, isPyPy
, pythonOlder
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "sure";
<<<<<<< HEAD
  version = "2.0.1";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-yPxvq8Dn9phO6ruUJUDkVkblvvC7mf5Z4C2mNOTUuco=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "rednose = 1" ""
  '';

  propagatedBuildInputs = [
    mock
    six
  ];

  nativeCheckInputs = [
    nose
  ];

=======
    sha256 = "34ae88c846046742ef074036bf311dc90ab152b7bc09c342b281cebf676727a2";
  };

  patches = [
    # https://github.com/gabrielfalcao/sure/issues/169
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/055baa81cd987e566de62a5657513937521a90d4/trunk/python310.diff";
      hash = "sha256-BKylV8xpTOuO/X4hzZKpoIcAQcdAK0kXYENRad7AGPc=";
    })
  ];

  propagatedBuildInputs = [
    six
    mock
  ];

  nativeCheckInputs = [
    rednose
  ];

  doCheck = pythonOlder "3.11";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "sure"
  ];

  meta = with lib; {
    description = "Utility belt for automated testing";
    homepage = "https://sure.readthedocs.io/";
<<<<<<< HEAD
    changelog = "https://github.com/gabrielfalcao/sure/blob/v${version}/CHANGELOG.md";
=======
    changelog = "https://github.com/gabrielfalcao/sure/blob/${version}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
