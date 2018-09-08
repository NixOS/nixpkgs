{ lib, buildPythonPackage, fetchPypi, EasyProcess }:

buildPythonPackage rec {
  pname = "PyVirtualDisplay";
  version = "0.2.1";

  propagatedBuildInputs = [ EasyProcess ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "012883851a992f9c53f0dc6a512765a95cf241bdb734af79e6bdfef95c6e9982";
  };

  # requires X server
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for Xvfb, Xephyr and Xvnc";
    homepage = https://github.com/ponty/pyvirtualdisplay;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
