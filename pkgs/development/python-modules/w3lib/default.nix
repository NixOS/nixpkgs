{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "1.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vshh300ay5wn5hwl9qcb32m71pz5s6miy0if56vm4nggy159inq";
  };

  buildInputs = [ six pytest ];

  meta = with stdenv.lib; {
    description = "A library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
  };

}
