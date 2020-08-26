{ stdenv, fetchPypi, buildPythonPackage, pytest, fake-useragent, scrapy }:

buildPythonPackage rec {
  pname = "scrapy-fake-useragent";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02mayk804vdl15wjpx7jcjkc4zgrra4izf6iv00mcxq4fd4ck03l";
  };

  propagatedBuildInputs = [ fake-useragent ];

  checkInputs = [ pytest scrapy ];

  meta = with stdenv.lib; {
    description = "Random User-Agent middleware based on fake-useragent";
    homepage = "https://github.com/alecxe/scrapy-fake-useragent";
    license = licenses.bsd3;
  };
}
