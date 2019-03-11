{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, isPyPy
}:

buildPythonPackage rec {
  pname = "suds-jurko";
  version = "0.6";
  disabled = isPyPy;  # lots of failures

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1s4radwf38kdh3jrn5acbidqlr66sx786fkwi0rgq61hn4n2bdqw";
  };

  buildInputs = [ pytest ];

  doCheck = false; # v0.6 is broken with recent pytest 4.x

  meta = with stdenv.lib; {
    description = "Lightweight SOAP client (Jurko's fork)";
    homepage = https://bitbucket.org/jurko/suds;
    license = licenses.lgpl3;
  };

}
