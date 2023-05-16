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
}:

buildPythonPackage rec {
  pname = "skodaconnect";
<<<<<<< HEAD
  version = "1.3.6";
=======
  version = "1.3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lendy007";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-gV/+mt6XxY1UcA1H8zM4pG1ugrDo0m876e3XG1yV32A=";
=======
    hash = "sha256-gLk+Dj2x2OHa6VIIoA7FesDKtg180MuCud2nYk9mYpM=";
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
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest>=5,<6'," ""
    substituteInPlace requirements.txt \
      --replace "pytest-asyncio" ""
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "skodaconnect"
  ];

  meta = with lib; {
    description = "Python module to communicate with Skoda Connect";
    homepage = "https://github.com/lendy007/skodaconnect";
    changelog = "https://github.com/lendy007/skodaconnect/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
