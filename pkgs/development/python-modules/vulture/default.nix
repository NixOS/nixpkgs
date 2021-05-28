{ stdenv, buildPythonPackage, fetchPypi, isPy27, coverage, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "vulture";
  version = "2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "933bf7f3848e9e39ecab6a12faa59d5185471c887534abac13baea6fe8138cc2";
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
