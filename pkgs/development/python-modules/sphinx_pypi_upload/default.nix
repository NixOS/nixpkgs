{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Sphinx-PyPI-upload";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f919a47ce7a7e6028dba809de81ae1297ac192347cf6fc54efca919d4865159";
  };

  meta = with stdenv.lib; {
    description = "Setuptools command for uploading Sphinx documentation to PyPI";
    homepage = https://bitbucket.org/jezdez/sphinx-pypi-upload/;
    license = licenses.bsd0;
  };

}
