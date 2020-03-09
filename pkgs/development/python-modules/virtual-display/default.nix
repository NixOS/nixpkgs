{ lib, buildPythonPackage, fetchPypi, EasyProcess }:

buildPythonPackage rec {
  pname = "PyVirtualDisplay";
  version = "0.2.5";

  propagatedBuildInputs = [ EasyProcess ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b267c8ffc98fcbd084ba852ab4caef3f22e9362bc5d117e1697e767553eaf41";
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
