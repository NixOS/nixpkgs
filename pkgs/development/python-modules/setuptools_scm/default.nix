{ stdenv, buildPythonPackage, fetchPypi, pip }:
buildPythonPackage rec {
  pname = "setuptools_scm";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1191f2a136b5e86f7ca8ab00a97ef7aef997131f1f6d4971be69a1ef387d8b40";
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
