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
  version = "1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WXcYVIi1ZwI5xziVGcqEy5BN3fEQH/825EWJjYcUVLE=";
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
