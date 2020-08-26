{ stdenv, buildPythonPackage, fetchPypi, isPy27, coverage, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "vulture";
  version = "2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab0dce458ab746212cc02ac10cf31912c43bbfdcccb49025745b00850beab086";
  };

  checkInputs = [ coverage pytest pytestcov ];
  checkPhase = "pytest";

  meta = with stdenv.lib; {
    description = "Finds unused code in Python programs";
    homepage = "https://github.com/jendrikseipp/vulture";
    license = licenses.mit;
    maintainers = with maintainers; [ mcwitt ];
  };
}
