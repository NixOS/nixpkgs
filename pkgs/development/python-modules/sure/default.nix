{ lib
, buildPythonPackage
, fetchPypi
, rednose
, six
, mock
, isPyPy
, pythonOlder
, fetchpatch
}:

buildPythonPackage rec {
  pname = "sure";
  version = "2.0.0";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "34ae88c846046742ef074036bf311dc90ab152b7bc09c342b281cebf676727a2";
  };

  patches = [
    # https://github.com/gabrielfalcao/sure/issues/169
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/055baa81cd987e566de62a5657513937521a90d4/trunk/python310.diff";
      sha256 = "sha256-BKylV8xpTOuO/X4hzZKpoIcAQcdAK0kXYENRad7AGPc=";
    })
  ];

  propagatedBuildInputs = [
    six
    mock
  ];

  checkInputs = [
    rednose
  ];

  doCheck = pythonOlder "3.11";

  pythonImportsCheck = [
    "sure"
  ];

  meta = with lib; {
    description = "Utility belt for automated testing";
    homepage = "https://sure.readthedocs.io/";
    changelog = "https://github.com/gabrielfalcao/sure/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
