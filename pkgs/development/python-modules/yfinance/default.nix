{ lib
, buildPythonPackage
, fetchFromGitHub
, multitasking
, numpy
, pandas
, requests
, lxml
}:

buildPythonPackage rec {
  pname = "yfinance";
  version = "0.1.72";

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-7dA5+PJhuj/KAZoHMxx34yfyxDeiIf6DhufymfvD8Gg=";
  };

  propagatedBuildInputs = [
    multitasking
    numpy
    pandas
    requests
    lxml
  ];

  doCheck = false;  # Tests require internet access
  pythonImportsCheck = [ "yfinance" ];

  meta = with lib; {
    description = "Yahoo! Finance market data downloader (+faster Pandas Datareader)";
    homepage = "https://aroussi.com/post/python-yahoo-finance";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
