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
  version = "0.1.61";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+tc0rwweGFaBkrl7LBHdsff98PuupqovKh4nRP3hRJ0=";
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
