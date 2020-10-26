{ stdenv, buildPythonPackage, fetchPypi, isPy27, requests}:

buildPythonPackage rec {
  pname = "update_checker";
  version = "0.18.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a2d45bb4ac585884a6b03f9eade9161cedd9e8111545141e9aa9058932acb13";
  };

  propagatedBuildInputs = [ requests ];

  # requires network
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A python module that will check for package updates";
    homepage = "https://github.com/bboe/update_checker";
    license = licenses.bsd2;
  };
}
