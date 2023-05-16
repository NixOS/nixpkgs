{ lib
, aiohttp
, beautifulsoup4
, buildPythonPackage
, cryptography
, fetchFromGitHub
, lxml
, pyjwt
, pythonOlder
, setuptools-scm
, xmltodict
}:

buildPythonPackage rec {
  pname = "seatconnect";
<<<<<<< HEAD
  version = "1.1.9";
=======
  version = "1.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "farfar";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-HITVrI0o94a61gy/TYSGFtLBYX4Rw/dK1o2/KsvHLTQ=";
=======
    rev = version;
    hash = "sha256-8ZqqNDLygHgtUzTgdb34+4BHuStXJXnl9fBfo0WSNZw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
    cryptography
    lxml
    pyjwt
    xmltodict
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest>=5,<6'," ""
    substituteInPlace requirements.txt \
      --replace "pytest-asyncio" ""
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Project only has a dummy test
  doCheck = false;

  pythonImportsCheck = [
    "seatconnect"
  ];

  meta = with lib; {
    description = "Python module to communicate with Seat Connect";
    homepage = "https://github.com/farfar/seatconnect";
<<<<<<< HEAD
    changelog = "https://github.com/Farfar/seatconnect/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
