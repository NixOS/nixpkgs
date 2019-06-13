{ stdenv, buildPythonPackage, fetchPypi, mock, six }:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14013e7563102d808aae0cb5b3b2326979236d4bcd54c343ea636761629920cd";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ mock ];

  meta = with stdenv.lib; {
    homepage = http://graphite.wikidot.com/;
    description = "Fixed size round-robin style database";
    maintainers = with maintainers; [ rickynils offline basvandijk ];
    license = licenses.asl20;
  };
}
