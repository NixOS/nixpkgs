{ lib
, appdirs
, buildPythonPackage
, fetchFromGitHub
, multitasking
, numpy
, pandas
, pythonOlder
, requests
, lxml
}:

buildPythonPackage rec {
  pname = "yfinance";
  version = "0.1.84";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-oa+vbaDYnk3ogRF8z3Ev1u2XNe6prf/54HSndigf1pQ=";
  };

  propagatedBuildInputs = [
    appdirs
    multitasking
    numpy
    pandas
    requests
    lxml
  ];

  # Tests require internet access
  doCheck = false;

  pythonImportsCheck = [
    "yfinance"
  ];

  meta = with lib; {
    description = "Yahoo! Finance market data downloader (+faster Pandas Datareader)";
    homepage = "https://aroussi.com/post/python-yahoo-finance";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
