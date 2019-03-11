{ stdenv, buildPythonPackage, fetchPypi, pip }:
buildPythonPackage rec {
  pname = "setuptools_scm";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52ab47715fa0fc7d8e6cd15168d1a69ba995feb1505131c3e814eb7087b57358";
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
