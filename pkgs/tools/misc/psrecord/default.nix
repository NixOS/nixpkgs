{ lib, buildPythonApplication, fetchPypi, psutil, matplotlib, pytest }:
buildPythonApplication rec {
  pname = "psrecord";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XUhBDlQ7ceXcRndwWswqdT22WBTTzL37yo1dOgmwU7E=";
  };

  propagatedBuildInputs = [
    psutil matplotlib
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    pytest psrecord
    runHook postCheck
  '';

  meta = {
    description = "Record the CPU and memory activity of a process";
    homepage = "https://github.com/astrofrog/psrecord";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ johnazoidberg ];
    mainProgram = "psrecord";
  };
}
