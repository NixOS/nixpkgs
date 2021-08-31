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
  version = "0.1.63";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    sha256 = "0k1saz0wknxv31vpqcfyi35mzi68c75hlqpw8lf83xqw9zllydhi";
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
