{ lib, isPy3k, buildPythonPackage, fetchPypi, GitPython
, tabulate, progress, click, plotly, colorlog, radon, dataclasses
}:

buildPythonPackage rec {
  pname = "wily";
  version = "1.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "193bs1h42bl23fca4fsmz3nbp5xj9mc0m9x61bfbfdml1kv10f71";
  };

  propagatedBuildInputs = [ GitPython tabulate progress click plotly colorlog radon ];

  disabled = !isPy3k;

  meta = with lib; {
    description = "A command-line application for tracking, reporting on complexity of Python tests and applications";
    homepage = https://github.com/tonybaloney/wily;
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
  };
}
