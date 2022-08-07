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
  version = "0.1.74";

  src = fetchFromGitHub {
    owner = "ranaroussi";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-3YOUdrLCluOuUieBwl15B6WHSXpMoNAjdeNJT3zmTTI=";
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
