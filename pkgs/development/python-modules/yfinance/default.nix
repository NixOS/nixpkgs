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
  version = "0.1.64";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    sha256 = "bde7ff6c04b7179881c15753460c600c4bd877dc9f33cdc98da68e7e1ebbc5a2";
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
