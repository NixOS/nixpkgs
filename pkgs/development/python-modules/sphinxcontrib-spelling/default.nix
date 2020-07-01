{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "312386e2b622830230611871ae507c5f73ec141d4a28aa97aaefed65fe579905";
  };

  propagatedBuildInputs = [ sphinx pyenchant pbr ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Sphinx spelling extension";
    homepage = "https://bitbucket.org/dhellmann/sphinxcontrib-spelling";
    maintainers = with maintainers; [ nand0p ];
    license = licenses.bsd2;
  };

}
