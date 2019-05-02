{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, pyenchant
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-spelling";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bcbaabef7aa9c176b81d960b20d0f67817ccea5e098968c366d2db4ad76d476";
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
