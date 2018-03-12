{ lib, buildPythonApplication, fetchFromGitHub }:

buildPythonApplication rec {
  pname = "pyprof2calltree";
  version = "1.4.3";

  # Fetch from GitHub because the PyPi packaged version does not
  # include all test files.
  src = fetchFromGitHub {
    owner = "pwaller";
    repo = "pyprof2calltree";
    rev = "v" + version;
    sha256 = "0i0a895zal193cpvzbv68fch606g4ik27rvzbby3vxk61zlxfqy5";
  };

  meta = with lib; {
    description = "Help visualize profiling data from cProfile with kcachegrind and qcachegrind";
    homepage = https://pypi.python.org/pypi/pyprof2calltree/;
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
