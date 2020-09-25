{ stdenv, fetchPypi, buildPythonPackage, pytest, scrapy, bsddb3 }:

buildPythonPackage rec {
  pname = "scrapy-deltafetch";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m511psddvlapg492ny36l8rzy7z4i39yx6a1agxzfz6s9b83fq8";
  };

  propagatedBuildInputs = [ bsddb3 scrapy ];

  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Scrapy spider middleware to ignore requests to pages containing items seen in previous crawls";
    homepage = "https://github.com/scrapy-plugins/scrapy-deltafetch";
    license = licenses.bsd3;
    maintainers = with maintainers; [ evanjs ];
  };
}
