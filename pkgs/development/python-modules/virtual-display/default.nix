{ lib, buildPythonPackage, fetchPypi, EasyProcess }:

buildPythonPackage rec {
  pname = "PyVirtualDisplay";
  version = "0.2.3";

  propagatedBuildInputs = [ EasyProcess ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "658d03ea2d6727cbe70c30af71e9014d3d39114a3c50bd661b75aad188fdd3aa";
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
