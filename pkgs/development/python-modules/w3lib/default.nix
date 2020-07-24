{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "1.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pv02lvvmgz2qb61vz1jkjc04fgm4hpfvaj5zm4i3mjp64hd1mha";
  };

  buildInputs = [ six pytest ];

  meta = with stdenv.lib; {
    description = "A library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
  };

}
