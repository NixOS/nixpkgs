{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "vnc2flv-20100207";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/v/vnc2flv/${name}.tar.gz";
    sha256 = "14d4nm8yim0bm0nd3wyj7z4zdsg5zk3d9bhhvwdc36x03r8d0sbq";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    description = "Tool to record VNC sessions to Flash Video";
    homepage = http://www.unixuser.org/~euske/python/vnc2flv/;
  };
}
