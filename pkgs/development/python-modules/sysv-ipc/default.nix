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
    hash = "sha256-DwY8vTbsIyAy5CV2nryHHxlafRg7mvMvmQFYnqcSmsM=";
  };

  meta = with lib; {
    description = "SysV IPC primitives (semaphores, shared memory and message queues)";
    license = licenses.bsd3;
    homepage = "http://semanchuk.com/philip/sysv_ipc/";
    maintainers = with maintainers; [ ris ];
  };
}
