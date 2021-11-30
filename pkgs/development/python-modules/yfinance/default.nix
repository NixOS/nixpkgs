{ lib
, buildPythonPackage
, fetchPypi
, multitasking
, numpy
, pandas
, requests
, lxml
}:

buildPythonPackage rec {
  pname = "yfinance";
  version = "0.1.66";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    sha256 = "9ea6fd18319fd898a8428a4a3d67171812b54779e330ead4d4ed0c59eb311be5";
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
