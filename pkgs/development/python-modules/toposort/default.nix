{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "toposort";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7428f56ef844f5055bb9e9e44b343983773ae6dce0fe5b101e08e27ffbd50ac";
  };

  meta = with stdenv.lib; {
    description = "A topological sort algorithm";
    homepage = "https://pypi.python.org/pypi/toposort/1.1";
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };

}
