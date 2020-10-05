{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e832c2b863f0f71df04a98e5976cf4da005ee6e9c03be41b3618d95a5fbfeb4";
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
