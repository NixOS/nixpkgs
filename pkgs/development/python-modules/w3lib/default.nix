{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "1.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55994787e93b411c2d659068b51b9998d9d0c05e0df188e6daf8f45836e1ea38";
  };

  buildInputs = [ six pytest ];

  meta = with stdenv.lib; {
    description = "A library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
  };

}
