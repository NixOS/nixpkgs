{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sysv_ipc";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p5lx3yz4p40rfb453m80a4hh8341yp4dki2nhhxz7bq2zfi1zwf";
  };

  meta = with stdenv.lib; {
    description = "SysV IPC primitives (semaphores, shared memory and message queues)";
    license = licenses.bsd3;
    homepage = http://semanchuk.com/philip/sysv_ipc/;
    maintainers = with maintainers; [ ris ];
  };

}
