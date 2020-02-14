{ stdenv, buildPythonPackage, fetchPypi, mock, six }:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dbb3b7cf4a02a080162467fff5cd38bf77940c3e2b25f7c4f78529427ca9cfe";
  };

  propagatedBuildInputs = [ six ];
  checkInputs = [ mock ];

  meta = with stdenv.lib; {
    homepage = http://graphite.wikidot.com/;
    description = "Fixed size round-robin style database";
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.asl20;
  };
}
