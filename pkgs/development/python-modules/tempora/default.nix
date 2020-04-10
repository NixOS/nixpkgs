{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, pytest, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools }:

buildPythonPackage rec {
  pname = "tempora";
  version = "1.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb60b1d2b1664104e307f8e5269d7f4acdb077c82e35cd57246ae14a3427d2d6";
  };

  buildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ six pytz jaraco_functools ];

  checkInputs = [ pytest freezegun backports_unittest-mock ];

  checkPhase = ''
    substituteInPlace pytest.ini --replace "--flake8" ""
    pytest
  '';

  meta = with lib; {
    description = "Objects and routines pertaining to date and time";
    homepage = "https://github.com/jaraco/tempora";
    license = licenses.mit;
  };
}
