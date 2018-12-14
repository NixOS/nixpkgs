{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "toposort";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1papqmv5930xl3d5mx2drnwdxg7y1y3l1ij2n0vvzqwnaa2ax9fv";
  };

  meta = with stdenv.lib; {
    description = "A topological sort algorithm";
    homepage = https://pypi.python.org/pypi/toposort/1.5;
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };

}
