{ lib
, buildPythonPackage
, fetchPypi
, multitasking
, numpy
, pandas
, requests
}:

buildPythonPackage rec {
  pname = "yfinance";
  version = "0.1.54";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    sha256 = "cee223cbd31e14955869f7978bcf83776d644345c7dea31ba5d41c309bfb0d3d";
  };

  propagatedBuildInputs = [
    multitasking
    numpy
    pandas
    requests
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
