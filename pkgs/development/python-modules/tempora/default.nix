{ lib, buildPythonPackage, fetchPypi
, setuptools_scm
, six, pytz, jaraco_functools }:

buildPythonPackage rec {
  pname = "tempora";
  version = "1.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb60b1d2b1664104e307f8e5269d7f4acdb077c82e35cd57246ae14a3427d2d6";
  };

  doCheck = false;

  buildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ six pytz jaraco_functools ];

  meta = with lib; {
    description = "Objects and routines pertaining to date and time";
    homepage = https://github.com/jaraco/tempora;
    license = licenses.mit;
  };
}
