{ stdenv, buildPythonPackage, fetchPypi, pip }:

buildPythonPackage rec {
  pname = "setuptools_scm";
  version = "3.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19cyndx23xmpbhz4qrwmfwsmnnaczd0dw7qg977ksq2dbvxy29dx";
  };

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/pypa/setuptools_scm/;
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
