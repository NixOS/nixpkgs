{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "toposort";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dba5ae845296e3bf37b042c640870ffebcdeb8cd4df45adaa01d8c5476c557dd";
  };

  meta = with stdenv.lib; {
    description = "A topological sort algorithm";
    homepage = https://pypi.python.org/pypi/toposort/1.1;
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };

}
