{ lib, buildPythonPackage, fetchPypi
, setuptools_scm
, six, pytz, jaraco_functools }:

buildPythonPackage rec {
  pname = "tempora";
  version = "1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4951da790bd369f718dbe2287adbdc289dc2575a09278e77fad6131bcfe93097";
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
