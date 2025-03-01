{
  lib,
  buildPythonApplication,
  fetchPypi,
  psutil,
  matplotlib,
  pytest,
}:
buildPythonApplication rec {
  pname = "psrecord";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d48410e543b71e5dc4677705acc2a753db65814d3ccbdfbca8d5d3a09b053b1";
  };

  propagatedBuildInputs = [
    psutil
    matplotlib
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
