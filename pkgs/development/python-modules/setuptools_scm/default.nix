{ stdenv, buildPythonPackage, fetchPypi, pip }:
buildPythonPackage rec {
  pname = "setuptools_scm";
  name = "${pname}-${version}";
  version = "1.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70a4cf5584e966ae92f54a764e6437af992ba42ac4bca7eb37cc5d02b98ec40a";
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
