{ lib, buildPythonPackage, fetchPypi, dateutil }:

buildPythonPackage rec {
  pname = "timew-report";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z94wsq6xnrff2wlywp95p1gpjicply1mxjr8xyjr1n7vkw0fgfc";
  };

  propagatedBuildInputs = [ dateutil ];

  meta = {
    description = "An interface for TimeWarrior report data";
    homepage = https://github.com/lauft/timew-report;
    license = lib.licenses.mit;
  };
}
