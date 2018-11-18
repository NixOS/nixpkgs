{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f0fymrk4kvhqs0vj9gay4lhacxkfrlrpj4gvg0p4wjdczplxd3z";
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
