{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "5.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f220647f1d9270bd90f0a42146b75a03c51a60184ced6584a9e5ef8f385b5a1";
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
