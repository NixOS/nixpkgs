{ lib, buildPythonPackage, fetchPypi, EasyProcess }:

buildPythonPackage rec {
  pname = "PyVirtualDisplay";
  version = "2.1";

  propagatedBuildInputs = [ EasyProcess ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d4c6957ec2c4753b5293fb6a60a90d7c27fc01bc5de9b5aa863f7c1e3fb4efc";
  };

  # requires X server
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for Xvfb, Xephyr and Xvnc";
    homepage = "https://github.com/ponty/pyvirtualdisplay";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
