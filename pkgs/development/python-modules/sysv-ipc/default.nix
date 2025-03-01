{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "sysv-ipc";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "sysv_ipc";
    inherit version;
    sha256 = "0f063cbd36ec232032e425769ebc871f195a7d183b9af32f9901589ea7129ac3";
  };

  meta = with lib; {
    description = "SysV IPC primitives (semaphores, shared memory and message queues)";
    license = licenses.bsd3;
    homepage = "http://semanchuk.com/philip/sysv_ipc/";
    maintainers = with maintainers; [ ris ];
  };
}
