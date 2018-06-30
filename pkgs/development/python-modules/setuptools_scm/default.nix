{ stdenv, buildPythonPackage, fetchPypi, pip }:
buildPythonPackage rec {
  pname = "setuptools_scm";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a767141fecdab1c0b3c8e4c788ac912d7c94a0d6c452d40777ba84f918316379";
  };

  buildInputs = [ pip ];

  # Seems to fail due to chroot and would cause circular dependency
  # with pytest
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/pypa/setuptools_scm/;
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ jgeerds ];
  };
}
