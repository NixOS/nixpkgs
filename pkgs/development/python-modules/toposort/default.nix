{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "toposort";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1izmirbwmd9xrk7rq83p486cvnsslfa5ljvl7rijj1r64zkcnf3a";
  };

  meta = with stdenv.lib; {
    description = "A topological sort algorithm";
    homepage = https://pypi.python.org/pypi/toposort/1.1;
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };

}
