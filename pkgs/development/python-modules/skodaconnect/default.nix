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
  version = "1.1.19";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lendy007";
    repo = pname;
    rev = version;
    hash = "sha256-IbCGveRcn6Kn0kGw+/kWTBTqCdWqsPTv6aPq71vc1mw=";
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
