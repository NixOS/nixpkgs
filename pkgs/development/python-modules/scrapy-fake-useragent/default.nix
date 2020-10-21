{ stdenv, fetchPypi, buildPythonPackage, pytest, fake-useragent, scrapy }:

buildPythonPackage rec {
  pname = "scrapy-fake-useragent";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b17e982e646918dc25080da0672812d07bfb7a92a58377c014c74e0182c665e";
  };

  propagatedBuildInputs = [ fake-useragent ];

  checkInputs = [ pytest scrapy ];

  meta = with stdenv.lib; {
    description = "Random User-Agent middleware based on fake-useragent";
    homepage = "https://github.com/alecxe/scrapy-fake-useragent";
    license = licenses.mit;
  };
}
