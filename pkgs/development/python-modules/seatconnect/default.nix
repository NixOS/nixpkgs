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
  version = "1.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "farfar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EOaFZch/C9N4lacZ4IqIJUVSaEn8wOFN/WN6WOL/1mo=";
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest>=5,<6'," ""
    substituteInPlace requirements.txt \
      --replace "pytest-asyncio" ""
  '';

  # Project only has a dummy test
  doCheck = false;

  pythonImportsCheck = [
    "seatconnect"
  ];

  meta = with lib; {
    description = "Python module to communicate with Seat Connect";
    homepage = "https://github.com/farfar/seatconnect";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
