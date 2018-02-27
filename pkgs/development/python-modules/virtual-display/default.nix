{ lib, buildPythonPackage, fetchPypi, EasyProcess }:

buildPythonPackage rec {
  pname = "PyVirtualDisplay";
  version = "0.1.5";

  propagatedBuildInputs = [ EasyProcess ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa6aef08995e14c20cc670d933bfa6e70d736d0b555af309b2e989e2faa9ee53";
  };

  meta = with lib; {
    description = "Python wrapper for Xvfb, Xephyr and Xvnc";
    homepage = "https://github.com/ponty/pyvirtualdisplay";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
