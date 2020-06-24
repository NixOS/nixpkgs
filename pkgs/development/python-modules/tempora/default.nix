{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, pytest, freezegun, backports_unittest-mock
, pytest-black, pytestcov, pytest-flake8
, six, pytz, jaraco_functools }:

buildPythonPackage rec {
  pname = "tempora";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e370d822cf48f5356aab0734ea45807250f5120e291c76712a1d766b49ae34f8";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ six pytz jaraco_functools ];

  checkInputs = [ pytest pytest-flake8 pytest-black pytestcov freezegun backports_unittest-mock ];

  # missing pytest-freezegun package
  checkPhase = ''
    pytest -k 'not get_nearest_year_for_day'
  '';

  meta = with lib; {
    description = "Objects and routines pertaining to date and time";
    homepage = "https://github.com/jaraco/tempora";
    license = licenses.mit;
  };
}
