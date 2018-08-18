{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ahzsxk52ws8k3kdq52qbsbsx2r9z350j8gg9adw4x5fjwksz4r8";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = http://graphite.wikidot.com/;
    description = "Fixed size round-robin style database";
    maintainers = with maintainers; [ rickynils offline basvandijk ];
    license = licenses.asl20;
  };
}
