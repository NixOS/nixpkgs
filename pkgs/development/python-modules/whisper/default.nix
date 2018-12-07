{ stdenv, buildPythonPackage, fetchPypi, mock, six }:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee9128873b5f9c97d258d35d0a32ef8e62c9da473fbbd056982df1f36f0b37aa";
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
