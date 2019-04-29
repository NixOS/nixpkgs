{ buildPythonPackage, fetchPypi, lib
, scrapy, six, w3lib
}:

buildPythonPackage rec {
  pname = "scrapy-crawlera";
  version = "1.5.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0ia92rf8wxai7m8qpcsfy360fd76zy1bx6dmnyzdjc0in16n7vww";
  };

  propagatedBuildInputs = [ scrapy six w3lib ];

  # Tests are network-based
  doCheck = false;

  meta = with lib; {
    description = "Provides easy use of Crawlera with Scrapy";
    license = licenses.bsd3;
    homepage = https://scrapy-crawlera.readthedocs.io/;
    maintainers = with maintainers; [ mredaelli ];
  };
}
