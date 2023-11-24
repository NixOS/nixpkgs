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
  version = "1.1.9";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "farfar";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-HITVrI0o94a61gy/TYSGFtLBYX4Rw/dK1o2/KsvHLTQ=";
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

  # Project only has a dummy test
  doCheck = false;

  pythonImportsCheck = [
    "seatconnect"
  ];

  meta = with lib; {
    description = "Python module to communicate with Seat Connect";
    homepage = "https://github.com/farfar/seatconnect";
    changelog = "https://github.com/Farfar/seatconnect/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
