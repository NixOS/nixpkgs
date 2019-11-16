{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0304dac9286378f9c608af8d885a08fe03a9c62b3ebfa8802008018d92371c19";
  };

  propagatedBuildInputs = [ sphinx pyenchant pbr ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Sphinx spelling extension";
    homepage = https://bitbucket.org/dhellmann/sphinxcontrib-spelling;
    maintainers = with maintainers; [ nand0p ];
    license = licenses.bsd2;
  };

}
