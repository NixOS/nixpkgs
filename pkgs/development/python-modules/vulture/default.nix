{ stdenv, buildPythonPackage, fetchPypi, coverage, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "vulture";
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sbwbwkpk3s7iwnwsdrvj1ydw9lgbn3xqhji7f8y5y6vvr77i53v";
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
