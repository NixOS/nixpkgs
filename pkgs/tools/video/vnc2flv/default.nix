{ lib, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "vnc2flv";
  version = "20100207";

  src = fetchurl {
    url = "mirror://pypi/v/vnc2flv/${pname}-${version}.tar.gz";
    sha256 = "14d4nm8yim0bm0nd3wyj7z4zdsg5zk3d9bhhvwdc36x03r8d0sbq";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    description = "Tool to record VNC sessions to Flash Video";
    homepage = "https://www.unixuser.org/~euske/python/vnc2flv/";
    license = lib.licenses.mit;
  };
}
