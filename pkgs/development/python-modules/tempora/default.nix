{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, pytest, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools }:

buildPythonPackage rec {
  pname = "tempora";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e370d822cf48f5356aab0734ea45807250f5120e291c76712a1d766b49ae34f8";
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
