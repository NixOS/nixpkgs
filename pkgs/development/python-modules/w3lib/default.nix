{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "1.21.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05a3fxi4f43n0dc87lizsy2h84dxvqjy0q6rhkyabdbhypz5864b";
  };

  buildInputs = [ six pytest ];

  meta = with stdenv.lib; {
    description = "A library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
  };

}
