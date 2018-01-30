{ lib, buildPythonApplication, fetchPypi, setuptools, python }:

buildPythonApplication rec {
  pname = "pyprof2calltree";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38a0774f7716d5303d4c57ff89ec24258154942666e4404558f6ac10f8bb1e52";
  };

  # Check disabled because of upstream packaging bug
  # https://github.com/NixOS/nixpkgs/pull/34379#discussion_r164498796
  # checkInputs = [ setuptools ];
  # checkPhase = ''
  #   ${python.interpreter} -m unittest discover -s test
  # '';
  doCheck = false;

  meta = with lib; {
    description = "Help visualize profiling data from cProfile with kcachegrind and qcachegrind";
    homepage = https://pypi.python.org/pypi/pyprof2calltree/;
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
