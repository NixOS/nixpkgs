{ stdenv, buildPythonPackage, fetchPypi, mock, six }:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08biw3g6x6p2aa1nlvfazbgcs1xvf6m0hvskdjhgwnsbwxk1xq46";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ mock ];

  meta = with stdenv.lib; {
    homepage = "http://graphite.wikidot.com/";
    description = "Fixed size round-robin style database";
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.asl20;
  };
}
