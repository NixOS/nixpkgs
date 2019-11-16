{ lib, buildPythonApplication, fetchPypi, psutil, matplotlib, pytest }:
buildPythonApplication rec {
  pname = "psrecord";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "151rynca97v5wq1drl2yfrqmqil1km72cizn3159c2ip14626mp6";
  };

  propagatedBuildInputs = [
    psutil matplotlib
  ];

  checkInputs = [
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
  };
}
