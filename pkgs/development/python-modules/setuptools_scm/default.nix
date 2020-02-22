{ stdenv, buildPythonPackage, fetchPypi, pip, pytest }:

buildPythonPackage rec {
  pname = "setuptools_scm";
  version = "3.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26b8a108783cd88f4b15ff1f0f347d6b476db25d0c226159b835d713f9487320";
  };

  # Requires pytest, circular dependency
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/pypa/setuptools_scm/;
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
