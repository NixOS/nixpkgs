{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "vnc2flv-20100207";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/v/vnc2flv/${name}.tar.gz";
    md5 = "8492e46496e187b49fe5569b5639804e";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    description = "Tool to record VNC sessions to Flash Video";
    homepage = http://www.unixuser.org/~euske/python/vnc2flv/;
  };
}
