{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "sysv-ipc";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "sysv_ipc";
    inherit version;
    sha256 = "sha256-75arM7ti5NFBQvC+BSTcwMPHDJZELfL8dzxnt8dRQZk=";
  };

  meta = {
    description = "SysV IPC primitives (semaphores, shared memory and message queues)";
    license = lib.licenses.bsd3;
    homepage = "http://semanchuk.com/philip/sysv_ipc/";
    maintainers = with lib.maintainers; [ ris ];
  };
}
