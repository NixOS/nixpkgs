{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "socid-extractor";
  version = "0.0.26";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "soxoj";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3ht/wlxB40k4n0DTBGAvAl7yPiUIZqAe+ECbtkyMTzk=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    python-dateutil
    requests
  ];

  postPatch = ''
    # https://github.com/soxoj/socid-extractor/pull/150
    substituteInPlace requirements.txt \
      --replace "beautifulsoup4~=4.11.1" "beautifulsoup4>=4.10.0"
  '';

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [
    "socid_extractor"
  ];

  meta = with lib; {
    description = "Python module to extract details from personal pages";
    homepage = "https://github.com/soxoj/socid-extractor";
    changelog = "https://github.com/soxoj/socid-extractor/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
