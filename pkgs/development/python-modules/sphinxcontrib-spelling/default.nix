{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44a9445b237ade895ae1fccbe6f41422489b1ffb2a026c1b78b0c1c1c229f9bf";
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
