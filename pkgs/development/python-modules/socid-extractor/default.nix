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
    sha256 = "0vdcxinpnl3vn2l4dybbyggdzm5mpmi3qbpars7lrg5m0mib0cml";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    python-dateutil
    requests
  ];

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
