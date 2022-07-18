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
  version = "0.0.23";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "soxoj";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tDKwYgW1vEyPzuouPGK9tdTf3vNr+UaosHtQe23srG0=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    python-dateutil
    requests
  ];

  postPatch = ''
    # https://github.com/soxoj/socid-extractor/pull/125
    substituteInPlace requirements.txt \
      --replace "beautifulsoup4~=4.10.0" "beautifulsoup4>=4.10.0"
  '';

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [
    "socid_extractor"
  ];

  meta = with lib; {
    description = "Python module to extract details from personal pages";
    homepage = "https://github.com/soxoj/socid-extractor";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
