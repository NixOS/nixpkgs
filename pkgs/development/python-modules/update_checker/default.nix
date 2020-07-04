{ stdenv, buildPythonPackage, fetchPypi, requests}:

buildPythonPackage rec {
  pname = "update_checker";
  version = "0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qhfn5fjjab50gbnj2053wdfppzkydqgapfz35ymrm1vysvqvvrd";
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
