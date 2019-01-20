{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "1.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mqwlc1cr15jxr3gr8pqqh5gf0gppm2kcvdi8vid6y8wmq9bjkg5";
  };

  buildInputs = [ six pytest ];

  meta = with stdenv.lib; {
    description = "A library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
  };

}
